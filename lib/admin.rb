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

        #update rooms array(WAVE #2)

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
      total_days = (date_range[:end_date] - date_range[:start_date]).to_i
      cost = (total_days - 1) * cost_per_day
      return Hotel::Reservation.new(date_range, cost)
    end

    def get_reservation_list(date)
      reservation_list = []
      if reservations.length != 0
        #iterate through reservations
        # reservations.select {|reservation| }
        #check date against start and end dates of each reservation
          #if date is within the range, add reservation to list of reservations
        #return reservation_list
      else
        return reservation_list
      end
    end

    def compare_dates(reservation, date)
      start_date = reservation.start_date
      end_date = reservation.end_date

      #date is w/i the reservation date_range
      if ((date <=> start_date) == 1) && ((end_date <=> date) == 1)
        return true
      #date is not w/i the reservation date_range
      elsif ((date <=> start_date) == -1) || ((end_date <=> date) == -1)
        return false
      #date is either equal to the start_date or the end_date
      else
        return true
      end
    end

  end
end
