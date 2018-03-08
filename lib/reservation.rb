module Hotel
  class Reservation

    attr_reader :start_date, :end_date, :cost_per_night, :cost, :room, :reservation_id

    def initialize(date_range, room)
      @start_date = date_range[:start_date]
      @end_date = date_range[:end_date]
      @cost_per_night = 200
      @cost = calculate_cost
      @room = room
    end

    def calculate_cost
      total_days = (end_date - start_date).to_i

      if total_days == 0
        raise StandardError.new("Start date cannot equal end date.")
      elsif total_days == 1
        cost = cost_per_night
      else
        cost = (total_days - 1) * cost_per_night
      end

      return cost
    end

  end
end
