module Hotel
  class Reservation

    attr_reader :start_date, :end_date, :cost, :room_id, :reservation_id

    def initialize(date_range)
      @start_date = date_range[:start_date]
      @end_date = date_range[:end_date]
      @cost = calculate_cost
      @room_id = 1
      #TODO: @reservation_id = get_id
    end

    def calculate_cost
      total_days = (end_date - start_date).to_i
      cost = (total_days - 1) * 200
      return cost
    end

    # def get_id
    #
    # end

  end
end
