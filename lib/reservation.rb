module Hotel
  class Reservation

    attr_reader :start_date, :end_date, :cost, :room_id, :reservation_id

    def initialize(date_range, cost)
      @start_date = date_range[:start_date]
      @end_date = date_range[:end_date]
      @cost = cost
      @room_id = 1
      @reservation_id = get_id
    end

  end
end
