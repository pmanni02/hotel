require_relative 'spec_helper'

describe "Reservation Class" do
  before do
    date_range = {
      start_date: Date.new(2018, 03, 05),
      end_date: Date.new(2018, 03, 10)
    }

    room = Hotel::Room.new(1, false)
    @reservation = Hotel::Reservation.new(date_range, room)
  end

  describe "Initializer" do
    it "is an instance of Reservation" do
      @reservation.must_be_instance_of Hotel::Reservation
    end

    it "correctly initializes instance variables" do
      @reservation.start_date.must_be_kind_of Date
      @reservation.end_date.must_be_kind_of Date
      @reservation.cost_per_night.must_be_kind_of Integer
      @reservation.total_cost.must_be_kind_of Integer
      @reservation.room.must_be_instance_of Hotel::Room
    end
  end

  describe "#calculate_cost" do
    it "accurately calculates cost" do
      @reservation.total_cost.must_equal 800
    end

    it "raises StandardError if start_date == end_date" do
      zero_days = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 05)
      }
      room = Hotel::Room.new(1, true)

      proc {
        Hotel::Reservation.new(one_day, room)
      }.must_raise StandardError
    end

    it "accurately calculates cost for one day" do
      one_day = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 06)
      }
      room = Hotel::Room.new(1, true)
      reservation = Hotel::Reservation.new(one_day, room)
      reservation.total_cost.must_equal 200
    end

    it "accurately calculates cost for room in a block with 4 rooms" do
      date_range = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 10)
      }
      # calculate cost using cost_per_night function in admin
      room = Hotel::Room.new(1, true, is_in_block: true)
      cost = 160 #cost_per_night for 4 rooms
      reservation = Hotel::Reservation.new(date_range, room, cost_per_night: cost)
      reservation.total_cost.must_equal 640
    end
  end

end
