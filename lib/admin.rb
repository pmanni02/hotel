require_relative 'reservation'
require_relative 'room'

module Hotel
  class Admin

    attr_reader :reservations, :num_rooms, :rooms

    def initialize
      @reservations = []
      @num_rooms = 20
      @rooms = create_rooms
    end

    def create_rooms
      rooms = []
      num_rooms.times do |i|
        id = i + 1
        rooms << create_room_instance(id)
      end
      return rooms
    end

    def create_room_instance(id)
      return Hotel::Room.new(id)
    end

  end
end
