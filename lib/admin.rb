require_relative 'reservation'
require_relative 'room'

require 'date'

module Hotel

  class Admin



    attr_reader :reservations, :num_rooms, :rooms, :base_rate, :discount_rate

    def initialize
      @reservations = []
      @num_rooms = 20
      @rooms = create_rooms_array
      @base_rate = 200
      @discount_rate = 0.05
    end

#---------------------------------------------------------------------#

    def create_rooms_array
      rooms = []
      is_reserved = false
      # is_in_block = false
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

    #TODO: add #make_block(date_range {}, # of rooms)
    # def make_block(date_range, # of rooms)
    #   call get_unreserved_rooms(date_range)
    #   check if #rooms if available
    #   calculate room_rate(# of rooms)
    #   make block hash and push into block array (@blocks)
    # end

    #TODO: add #add_reservation_in_block(room_id)
    # def add_reservation_in_block(room_id)
    #   check if room is in block
    #   if T, get date range and cost/night from block hash
    #   call add_reservation(date_range, room_id)
    #     Hotel::Reservation.new(date_range, room, cost/night)
    # end

    def add_reservation(date_range, room_id)
      if check_date_range(date_range) && get_unreserved_rooms(date_range).include?(room_id)
        selected_room = get_room(room_id)
        selected_room.is_reserved = true
        selected_room.is_in_block = true

        # num_rooms = 4
        # cost = cost_per_night(num_rooms)
        # new_reservation = Hotel::Reservation.new(date_range, selected_room, cost_per_night: cost)
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
    #NOTE: will not return rooms in blocks.
    def get_unreserved_rooms(date_range)
      desired_start_date = date_range[:start_date]
      desired_end_date = date_range[:end_date]

      #TODO: make each do block below a separate helper method -> check_reservations(date_range). returns unreserved_room_ids
      #TODO: add if statement that checks if reservation.room.is_in_block is false (IS THIS REDUNDANT!!)
      unreserved_room_ids = []
      reservations.each do |reservation|
        reservation_start = reservation.start_date
        reservation_end = reservation.end_date

        if desired_end_date <= reservation_start || desired_start_date >= reservation_end
          unreserved_room_ids << reservation.room.room_id
        end
      end

      unreserved_room_ids += check_rooms(rooms)

      return unreserved_room_ids.sort.uniq
    end

#---------------------------------------------------------------------#

    # def check_reservations(array_of_reservations)
    #
    # end

    #TODO: raise error if parameter is not an Array
    def check_rooms(array_of_rooms)
      unreserved_room_ids = []
      array_of_rooms.each do |room|
        if room.is_reserved == false && room.is_in_block == false
          unreserved_room_ids << room.room_id
        end
      end
      return unreserved_room_ids
    end

    # def check_block(array_of_blocks)
    # => call check_rooms(array of rooms from block)
    # end



    private

    def cost_per_night(num_rooms)
      return base_rate - (base_rate*(discount_rate * num_rooms))
    end

    #TODO: add PRIVATE get_room(id) method
    def get_room(id)
      return rooms.select {|room| room.room_id == id}.first
    end

    #TODO: add PRIVATE get_block(id) method
    # def get_block(room_id)
    # => returns block hash
    # end

  end
end
