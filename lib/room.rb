module Hotel
  class Room

    attr_reader :room_id
    attr_accessor :is_reserved

    def initialize(id, is_reserved)
      @room_id = id
      @is_reserved = is_reserved
    end

  end
end
