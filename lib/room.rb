module Hotel
  class Room

    attr_reader :room_id
    attr_accessor :is_reserved

    def initialize(id, is_reserved)
      @room_id = id
      @is_reserved = is_reserved
      #TODO: add @is_in_block 
    end

  end
end
