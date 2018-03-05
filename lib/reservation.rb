module Hotel
  class Reservation

    attr_reader :start_date, :end_date, :cost, :room_id, :reservation_id

    def initialize(date_range)
      @start_date = date_range[:start_date]
      @end_date = date_range[:end_date]
      @cost = 0.0
      @room_id = 0
      @reservation_id = 0
    end

  end
end
