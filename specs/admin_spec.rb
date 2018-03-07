require_relative 'spec_helper'
require 'date'
require 'pry'

describe "Admin class" do

  before do
    @admin = Hotel::Admin.new
  end

  describe "Initializer" do
    it "is an instance of Admin" do
      @admin.must_be_instance_of Hotel::Admin
    end

    it "creates initial data structures" do
      @admin.reservations.must_be_kind_of Array
      @admin.num_rooms.must_be_kind_of Integer
      @admin.rooms.must_be_kind_of Array
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
    end

    it "returns a Room instance" do
      room = @admin.create_room_instance(@id)
      room.must_be_instance_of Hotel::Room
    end

    it "raises an ArgumentError if id is not an Integer" do
      proc {
        @admin.create_room_instance(@bad_id)
      }.must_raise ArgumentError
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
    end

    it "returns true for a valid date range" do
      reservation = @admin.check_date_range(@date_range)
      reservation.must_equal true
    end

    it "returns false for an invalid date range" do
      reservation = @admin.check_date_range(@bad_date_range)
      reservation.must_equal false
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

    it "returns correct array if date is end_date of a reservation" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      list = @admin.get_reservation_list(Date.new(2018, 03, 10))

      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns correct array if date is start_date of a reservation" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      list = @admin.get_reservation_list(Date.new(2018, 03, 05))

      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns correct array if date is in between start_date and end_date" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      room_id = 1
      @admin.add_reservation(date_range, room_id)
      list = @admin.get_reservation_list(Date.new(2018, 03, 06))

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
      compare.must_be :>=, 0
    end

    it "returns true if date == start_date of a reservation" do
      date = Date.new(2018, 03, 05)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_be :>=, 0
    end

    it "returns true if date == end_date of a reservation" do
      date = Date.new(2018, 03, 10)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_be :>=, 0
    end

    it "returns false if date is NOT w/i date range of the reservation" do
      date = Date.new(2018, 04, 01)
      compare = @admin.compare_dates(@reservation, date)
      compare.must_be :<, 0
    end
  end

  describe "#get_unreserved_rooms(date_range)" do
    before do
      @date_range1 = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }

      @date_range2 = {
        start_date: Date.new(2018, 03, 01),
        end_date: Date.new(2018, 05, 20)
      }

      @date_range3 = {
        start_date: Date.new(2018, 05, 19),
        end_date: Date.new(2018, 05, 25)
      }

      @all_rooms = (1..20).to_a
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

    it "returns correct Array of Integers when there are multiple reservations" do
      room_id1 = 1
      room_id2 = 17
      room_id3 = 20
      @admin.add_reservation(@date_range1, room_id1)
      @admin.add_reservation(@date_range2, room_id2)
      @admin.add_reservation(@date_range3, room_id3)

      date_range = {
        start_date: Date.new(2018, 04, 02),
        end_date: Date.new(2018, 04, 06)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      #all rooms EXCEPT #17 should be available
      available_rooms.must_equal  [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20]
    end

    it "returns all rooms when start_date of new reservation == end date of one previous reservation" do
      room_id = 1
      @admin.add_reservation(@date_range1, room_id)

      date_range = {
        start_date: Date.new(2018, 03, 10),
        end_date: Date.new(2018, 03, 12)
      }

      available_rooms = @admin.get_unreserved_rooms(date_range)
      available_rooms.must_equal @all_rooms
    end
  end

end
