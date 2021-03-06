require_relative 'reservation'
require_relative 'room'

require 'date'

module Hotel

  class Admin

    attr_reader :reservations, :num_rooms, :rooms, :base_rate, :discount_rate, :blocks

    def initialize
      @reservations = []
      @blocks = []
      @num_rooms = 20
      @rooms = create_rooms_array
      @base_rate = 200
      @discount_rate = 0.05
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

    def create_room_instance(id, is_reserved)
      if id.class == Integer
        return Hotel::Room.new(id, is_reserved)
      else
        raise ArgumentError.new("ID is invalid")
      end
    end

#---------------------------------------------------------------------#

    def make_block(date_range, num_rooms_in_block)
      if num_rooms_in_block < 2 || num_rooms_in_block > 5
        raise StandardError.new("Blocks can only contain 2-5 rooms")
      end

      unreserved_room_ids = get_unreserved_rooms(date_range)
      if unreserved_room_ids.length >= num_rooms_in_block

        room_objs = get_room_objs(unreserved_room_ids.shift(num_rooms_in_block))
        room_objs.each do |room|
          room.is_in_block = room.in_block
        end

        block = {
          start_date: date_range[:start_date],
          end_date: date_range[:end_date],
          rooms: room_objs,
          room_rate: cost_per_night(num_rooms_in_block)
        }

        blocks << block
        return block
      else
        return nil
      end
    end

    def add_reservation_in_block(room_id)

      if room_id.class != Integer || room_id <= 0 || room_id > num_rooms
        raise ArgumentError.new("Invalid room ID")
      end
      block = get_block(room_id)
      if block != {}
        date_range = {}
        date_range[:start_date] = block[:start_date]
        date_range[:end_date] = block[:end_date]
        room = get_room(room_id)
        room.is_reserved = room.reserved
        cost = block[:room_rate]

        new_reservation = Hotel::Reservation.new(date_range, room, cost_per_night: cost)
        reservations << new_reservation
      else
        raise StandardError.new("That room is not in a block.")
      end

    end

    def add_reservation(date_range, room_id)
      if check_date_range(date_range) && get_unreserved_rooms(date_range).include?(room_id)
        selected_room = get_room(room_id)
        selected_room.is_reserved = true
        new_reservation = Hotel::Reservation.new(date_range, selected_room)
        reservations << new_reservation
        return new_reservation
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
      unreserved_room_ids = check_reservations(date_range, reservations)

      blocks.each do |block|
        block_start = block[:start_date]
        block_end = block[:end_date]
        room_objs = block[:rooms]
        room_ids = room_objs.map {|room| room.room_id}

        if date_range[:start_date] >= block_end == true
          next
        else
          if date_range[:end_date] <= block_start == false
            room_ids.each do |id|
              unreserved_room_ids.delete(id)
            end
          end
        end
      end

      return unreserved_room_ids.sort.uniq
    end

#---------------------------------------------------------------------#

    def check_reservations(date_range, reservations)
      desired_start_date = date_range[:start_date]
      desired_end_date = date_range[:end_date]

      unreserved_room_ids = (1..@num_rooms).to_a
      @reservations.each do |reservation|
        reservation_start = reservation.start_date
        reservation_end = reservation.end_date
        if desired_start_date >= reservation_end == true
          next
        else
          if desired_end_date <= reservation_start == false
            unreserved_room_ids.delete(reservation.room.room_id)
          end
        end
      end

      return unreserved_room_ids
    end

    def check_block(block)
      unreserved_room_ids = []
      rooms = block[:rooms]
      rooms.each do |room|
        if room.is_reserved == false
          unreserved_room_ids << room.room_id
        end
      end
      return unreserved_room_ids
    end

    def get_block(room_id)
      block = {}

      blocks.each do |b|
        rooms = b[:rooms]
        rooms.each do |r|
          if r.room_id == room_id
            block = b
            break
          end
        end
      end
      return block
    end

    private

    def cost_per_night(num_rooms)
      return base_rate - (base_rate*(discount_rate * num_rooms))
    end

    def get_room(id)
      return rooms.select {|room| room.room_id == id}.first
    end

    def get_room_objs(room_ids)
      room_objs = []
      i = 0
      while i < room_ids.length
        room_objs << get_room(room_ids[i])
        i += 1
      end
      return room_objs
    end

  end
end #end of module
