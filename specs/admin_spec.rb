require_relative 'spec_helper'
require 'date'
require 'pry'

describe "Admin Class" do
  before do
    @admin = Hotel::Admin.new
  end

  describe "Initializer" do
    it "is an instance of Admin" do
      @admin.must_be_instance_of Hotel::Admin
    end

    it "creates initial data structures" do
      @admin.reservations.must_be_kind_of Array
      @admin.blocks.must_be_kind_of Array
      @admin.num_rooms.must_be_kind_of Integer
      @admin.rooms.must_be_kind_of Array
      @admin.base_rate.must_be_kind_of Integer
      @admin.discount_rate.must_be_kind_of Float
    end
  end

  describe "#create_rooms" do
    before do
      @initial_rooms = @admin.create_rooms_array
    end

    it "returns an array of Room instances" do
      @initial_rooms.must_be_kind_of Array
      @initial_rooms.all? {|room| room.must_be_instance_of Hotel::Room}
    end

    it "assigns correct ids to Room instances" do
      @initial_rooms.first.room_id.must_equal 1
      @initial_rooms.last.room_id.must_equal 20
    end
  end

  describe "#create_room_instance" do
    before do
      @id = 1
      @bad_id = 'id'
      @is_reserved = false
    end

    it "returns a Room instance" do
      room = @admin.create_room_instance(@id, @is_reserved)
      room.must_be_instance_of Hotel::Room
    end

    it "raises an ArgumentError if id is not an Integer" do
      proc {
        @admin.create_room_instance(@bad_id, @is_reserved)
      }.must_raise ArgumentError
    end
  end

  describe "#make_block" do
    before do
      @date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
    end

    it "returns a hash" do
      num_rooms = 2
      block = @admin.make_block(@date_range, num_rooms)
      block.must_be_kind_of Hash
    end

    it "raises a StandardError if num_rooms < 2" do
      num_rooms = 1
      proc {
        @admin.make_block(@date_range, num_rooms)
      }.must_raise StandardError
    end

    it "returns nil if there are not enough rooms available" do
      @admin.num_rooms.times do |num|
        @admin.add_reservation(@date_range, num + 1)
      end
      num_rooms = 2
      block = @admin.make_block(@date_range, num_rooms)
      block.must_equal nil
    end

    it "returns the correct block" do
      num_rooms = 5
      block = @admin.make_block(@date_range, num_rooms)
      block[:start_date].must_equal Date.new(2018, 03, 05)
      block[:end_date].must_equal Date.new(2018, 03, 10)
      block[:rooms].must_be_kind_of Array
      block[:rooms].length.must_equal 5
      block[:room_rate].must_equal 150
    end

    it "returns a block with an Array of Room objs" do
      num_rooms = 5
      block = @admin.make_block(@date_range, num_rooms)
      rooms = block[:rooms]
      rooms.all? {|room| room.must_be_instance_of Hotel::Room}
      rooms.all? {|room| room.is_in_block.must_equal true}
    end
  end

  describe "#add_reservation_in_block" do
    before do
      @date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
    end

    it "raises a StandardError if room with room_id is not in a block" do
      room_id = 4
      @admin.add_reservation(@date_range, room_id)
      proc {
        @admin.add_reservation_in_block(room_id)
      }.must_raise StandardError
    end

    it "raises a ArgumentError if room_id is not valid integer" do
      room_id = "4"
      room_id2 = 55
      proc {
        @admin.add_reservation_in_block(room_id)
        @admin.add_reservation_in_block(room_id2)
      }.must_raise ArgumentError
    end

    it "successfully creates new reservation for valid room in block" do
      num_rooms = 2
      block = @admin.make_block(@date_range, num_rooms)
      rooms = block[:rooms]
      first_room = rooms.first

      first_room.is_reserved.must_equal false
      @admin.add_reservation_in_block(1)
      rooms = block[:rooms]
      rooms.first.is_in_block.must_equal true
      rooms.first.is_reserved.must_equal true
    end

  end

  describe "#add_reservation" do
    before do
      @date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }

      @bad_date_range = {
        start_date: Date.new(2018, 05, 05),
        end_date: Date.new(2018, 01, 01)
      }

      @room_id = 1
    end

    it "raises a StandardError for invalid date range" do
      proc {
        @admin.add_reservation(@bad_date_range, @room_id)
      }.must_raise StandardError
    end

    it "adds new reservation to reservations array" do
      initial_length = @admin.reservations.length
      @admin.add_reservation(@date_range, @room_id)
      new_length = @admin.reservations.length

      new_length.must_equal initial_length + 1
    end

    it "raises a StandardError if room is unavailable" do
      room_id = 1
      @admin.add_reservation(@date_range, room_id)
      proc {
        @admin.add_reservation(@date_range, room_id)
      }.must_raise StandardError
    end
  end

  describe "#check_date_range" do
    before do
      @date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }

      @bad_date_range = {
        start_date: Date.new(2018, 05, 05),
        end_date: Date.new(2018, 01, 01)
      }

      @one_day = {
        start_date: Date.new(2018, 05, 05),
        end_date: Date.new(2018, 05, 05)
      }
    end

    it "returns true for a valid date range" do
      reservation = @admin.check_date_range(@date_range)
      reservation.must_equal true
    end

    it "returns false for an invalid date range" do
      reservation = @admin.check_date_range(@bad_date_range)
      reservation.must_equal false
    end

    it "returns true if start_date == end_date" do
      reservation = @admin.check_date_range(@one_day)
      reservation.must_equal true
    end
  end

  describe "#get_reservation_list(date)" do
    it "returns an array" do
      date = Date.new(2018, 03, 05)
      list = @admin.get_reservation_list(date)
      list.must_be_kind_of Array
    end

    it "returns an empty array if there are no reservations" do
      date = Date.new(2018, 04, 05)
      @admin.get_reservation_list(date).must_equal []
    end

    it "returns one reservation if date is end_date of a reservation" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      list = @admin.get_reservation_list(Date.new(2018, 03, 10))

      list.length.must_equal 1
      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns one reservation if date is start_date of a reservation" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      list = @admin.get_reservation_list(Date.new(2018, 03, 05))

      list.length.must_equal 1
      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns one reservation if date is in between start_date and end_date" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      list = @admin.get_reservation_list(Date.new(2018, 03, 06))

      list.length.must_equal 1
      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns empty array if date is not in any reservations" do
      date_range1 = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      date_range2 = {
        start_date: Date.new(2017, 07, 05),
        end_date: Date.new(2017, 07, 23)
      }
      room_id = 1
      @admin.add_reservation(date_range1, room_id)
      @admin.add_reservation(date_range2, room_id)

      list = @admin.get_reservation_list(Date.new(2018, 03, 11))
      list.must_equal []
    end
  end

  describe "#compare_dates(reservation, date)" do
    before do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      @reservation = @admin.reservations.first
    end

    it "returns true if date is w/i date range of the reservation" do
      date = Date.new(2018, 03, 07)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_equal true
    end

    it "returns true if date == start_date of a reservation" do
      date = Date.new(2018, 03, 05)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_equal true
    end

    it "returns true if date == end_date of a reservation" do
      date = Date.new(2018, 03, 10)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_equal true
    end

    it "returns false if date is NOT w/i date range of the reservation" do
      date = Date.new(2018, 04, 01)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_equal false
    end
  end

  describe "#get_unreserved_rooms(date_range)" do
    before do
      @date_range1 = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
    end

    it "returns an Array of Integers (Room Ids)" do
      @admin.get_unreserved_rooms(@date_range1).must_be_kind_of Array
      @admin.get_unreserved_rooms(@date_range1).all? {
        |room| room.must_be_kind_of Integer
      }
    end

    it "returns an empty Array if there are no available rooms" do
      @admin.num_rooms.times do |num|
        @admin.add_reservation(@date_range1, num + 1)
      end

      available_rooms = @admin.get_unreserved_rooms(@date_range1)
      available_rooms.must_equal []
    end

    it "returns all room ids when start_date of new reservation == end date of one previous reservation" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 10),
        end_date: Date.new(2018, 03, 12)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal (1..20).to_a
    end

    it "returns 19 room ids when date range is completely within an established reservation range" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 06),
        end_date: Date.new(2018, 03, 9)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal (2..20).to_a
    end

    it "returns 19 room ids when date range is exactly the same as an established reservation range" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal (2..20).to_a
    end

    it "returns 20 room ids when date range is completely outside of an established reservation range" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 12),
        end_date: Date.new(2018, 03, 15)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal (1..20).to_a
    end

    it "returns 19 room ids when date range overlaps an established reservation range once" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 4),
        end_date: Date.new(2018, 03, 9)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal (2..20).to_a
    end

    it "returns 19 room ids when date range overlaps an established reservation range twice" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 4),
        end_date: Date.new(2018, 03, 12)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal (2..20).to_a
    end

    it "does not return rooms within a block" do
      num_rooms = 4
      block = @admin.make_block(@date_range1, num_rooms)
      unreserved_rooms_ids = @admin.get_unreserved_rooms(@date_range1)
      rooms = block[:rooms]

      rooms.any?{|room| unreserved_rooms_ids.include?(room.room_id)}.must_equal false
    end

    it "returns rooms within a block if start_date == end_date of block" do
      skip
      # make_block
      # make date range that starts the same day block ends
      # call get_unreserved_rooms(date_range)
      # unreserved_room_ids should into include ids in block
    end
  end

  describe "#check_reservations" do
    it "returns an array" do
      date_range = {
        start_date: Date.new(2018, 03, 5),
        end_date: Date.new(2018, 03, 10)
      }
      reservations = @admin.reservations
      @admin.check_reservations(date_range, reservations).must_be_kind_of Array
    end
  end

  describe "#check_rooms" do
    it "returns an array" do
      rooms = @admin.rooms
      @admin.check_rooms(rooms).must_be_kind_of Array
    end
  end

  describe "#get_block" do
    before do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      num_rooms = 3
      @block = @admin.make_block(date_range, num_rooms)
    end

    it "returns a block for rooms in block" do
      @admin.get_block(1).must_equal @block
      @admin.get_block(2).must_equal @block
      @admin.get_block(3).must_equal @block
    end

    it "returns empty {} if id is not in block" do
      @admin.get_block(4).wont_equal @block
    end
  end

end
