require_relative 'reservation'
require_relative 'room'

require 'date'

module Hotel
  class Admin

    attr_reader :reservations, :num_rooms, :rooms, :reservation_id_tracker

    def initialize
      @reservations = []
      @num_rooms = 20
      @rooms = create_rooms_array
      # @reservation_id_tracker = 0
    end

#---------------------------------------------------------------------#

    def create_rooms_array
      rooms = []
      is_reserved = false
      num_rooms.times do |i|
        id = i + 1
        rooms << create_room_instance(id, is_reserved)
      end
      return rooms
    end

    #TODO: Add check if id is within desired range
    def create_room_instance(id, is_reserved)
      if id.class == Integer
        return Hotel::Room.new(id, is_reserved)
      else
        raise ArgumentError.new("ID is invalid")
      end
    end

#---------------------------------------------------------------------#

    def add_reservation(date_range, room_id)
      if check_date_range(date_range) && get_unreserved_rooms(date_range).include?(room_id)
        selected_room = @rooms.select {|room| room.room_id == room_id}.first
        selected_room.is_reserved = true
        new_reservation = Hotel::Reservation.new(date_range, selected_room)
        reservations << new_reservation
      else
        raise StandardError.new("Date range OR room ID is invalid")
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

#---------------------------------------------------------------------#

    #TODO: add error if date is not a date object
    def get_reservation_list(date)
      if reservations.length != 0
        reservation_list = reservations.select { |reservation| compare_dates(reservation, date) }
        return reservation_list
      else
        return []
      end
    end

    def compare_dates(reservation, date)
      start_date = reservation.start_date
      end_date = reservation.end_date
      # date is w/i the reservation date_range
      if ((date <=> start_date) == 1) && ((end_date <=> date) == 1)
        return true
      # date is NOT w/i the reservation date_range (
      elsif ((date <=> start_date) == -1) || ((end_date <=> date) == -1)
        return false
      # date is either equal to the start_date or to the end_date (TRUE)
      elsif ((date <=> start_date) == 0) || ((end_date <=> date) == 0)
        return true
      end
    end

#---------------------------------------------------------------------#

    def get_unreserved_rooms(date_range)
      desired_start_date = date_range[:start_date]
      desired_end_date = date_range[:end_date]
      unreserved_rooms = []
      reservations.each do |reservation|
        reservation_start = reservation.start_date
        reservation_end = reservation.end_date

        if desired_end_date <= reservation_start || desired_start_date >= reservation_end
          unreserved_rooms << reservation.room.room_id
        end
      end

      rooms.each do |room|
        if room.is_reserved == false
          unreserved_rooms << room.room_id
        end
      end

      return unreserved_rooms.sort.uniq
    end

  end
end
