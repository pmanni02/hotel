require_relative 'reservation'
require_relative 'room'

require 'date'

module Hotel
  class Admin

    attr_reader :reservations, :num_rooms, :rooms, :cost_per_day, :reservation_id_tracker

    def initialize
      @reservations = []
      @num_rooms = 20
      @cost_per_day = 200
      # @reservation_id_tracker = 0
      @rooms = create_rooms_array
    end

    def create_rooms_array
      rooms = []
      num_rooms.times do |i|
        id = i + 1
        rooms << create_room_instance(id)
      end
      return rooms
    end

    def create_room_instance(id)
      if id.class == Integer
        return Hotel::Room.new(id)
      else
        raise ArgumentError.new("ID is invalid")
      end
    end

    def add_reservation(date_range)
      #is there an available room (WAVE #2)

      if check_date_range(date_range)
        #make reservation instance
        reservation = create_reservation(date_range)
        #add reservation to reservations array
        reservations << reservation
        #update rooms array

      else
        raise StandardError.new("Date range is invalid")
      end
    end

    def check_date_range(date_range)
      start_time = date_range[:start_date].to_time
      end_time = date_range[:end_date].to_time
      if end_time - start_time < 0
        return false
      else
        return true
      end
    end

    def create_reservation(date_range)
      total_days = (date_range[:start_date] - date_range[:end_date]).to_i
      cost = (total_days - 1) * cost_per_day
      return Hotel::Reservation.new(date_range, cost)
    end

  end
end
