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

  describe "#create_reservation" do
    before do
      @reservation_data = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }

      @bad_reservation_data = {
        start_date: Date.new(2018, 05, 05),
        end_date: Date.new(2018, 01, 01)
      }
    end

    it "raises a StandardError for invalid date range" do
      proc {
        @admin.create_reservation(@bad_reservation_data)
      }.must_raise StandardError
    end
  end

  describe "#check_reservation_data" do
    before do
      @reservation_data = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }

      @bad_reservation_data = {
        start_date: Date.new(2018, 05, 05),
        end_date: Date.new(2018, 01, 01)
      }
    end

    it "returns true for a valid date range" do
      reservation = @admin.check_reservation_data(@reservation_data)
      reservation.must_equal true
    end

    it "returns false for an invalid date range" do
      reservation = @admin.check_reservation_data(@bad_reservation_data)
      reservation.must_equal false
    end
  end

end
