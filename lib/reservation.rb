module Hotel
  class Reservation

    attr_reader :start_date, :end_date, :cost, :room_id, :reservation_id, :cost_per_day

    def initialize(date_range)
      @start_date = date_range[:start_date]
      @end_date = date_range[:end_date]
      @cost_per_day = 200
      @cost = calculate_cost
      @room_id = 1
      #TODO: @reservation_id = get_id
    end

    def calculate_cost
      total_days = (end_date - start_date).to_i
      if total_days > 0
        cost = (total_days - 1) * cost_per_day
        return cost
      else
        return cost_per_day
      end
    end

    # def get_id
    #
    # end

  end
end
