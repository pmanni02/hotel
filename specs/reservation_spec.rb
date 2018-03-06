require_relative 'spec_helper'

describe "Reservation class" do
  before do
    # cost = 800
    date_range = {
      start_date: Date.new(2018, 03, 05),
      end_date: Date.new(2018, 03, 10)
    }
    @reservation = Hotel::Reservation.new(date_range)
  end

  describe "Initializer" do
    it "is an instance of Reservation" do
      @reservation.must_be_instance_of Hotel::Reservation
    end

    it "correctly initializes instance variables" do
      @reservation.start_date.must_be_kind_of Date
      @reservation.end_date.must_be_kind_of Date
      @reservation.cost.must_be_kind_of Integer
      @reservation.room_id.must_be_kind_of Integer
      # @reservation.reservation_id.must_be_kind_of Integer
    end
  end

  describe "#calculate_cost" do
    it "accurately calculates cost" do
      @reservation.cost.must_equal 800
    end

    it "accurately calculates cost for one day" do
      one_day = {
        start_date: Date.new(2018, 03, 05),
        end_date: Date.new(2018, 03, 05)
      }
      reservation = Hotel::Reservation.new(one_day)
      reservation.cost.must_equal 200
    end
  end

  # describe "#get_id" do
  #   it "returns an Integer" do
  #     @reservation.get_id.must_be_kind_of Integer
  #   end
  # end
end
