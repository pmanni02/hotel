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
    end

    it "raises a StandardError for invalid date range" do
      proc {
        @admin.add_reservation(@bad_date_range)
      }.must_raise StandardError
    end

    it "adds new reservation to reservations array" do
      initial_length = @admin.reservations.length
      @admin.add_reservation(@date_range)
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

  describe "#create_reservation" do
    it "returns a Reservation instance" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      @admin.create_reservation(date_range).must_be_instance_of Hotel::Reservation
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
      @admin.add_reservation(date_range)
      list = @admin.get_reservation_list(Date.new(2018, 03, 10))

      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns correct array if date is start_date of a reservation" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      @admin.add_reservation(date_range)
      list = @admin.get_reservation_list(Date.new(2018, 03, 05))

      list.first.start_date.must_equal Date.new(2018, 03, 05)
      list.last.end_date.must_equal Date.new(2018, 03, 10)
    end

    it "returns correct array if date is in between start_date and end_date" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      @admin.add_reservation(date_range)
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
      @admin.add_reservation(date_range1)
      @admin.add_reservation(date_range2)

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
      @admin.add_reservation(date_range)
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

end
