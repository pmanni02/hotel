module Hotel
  class Room

    attr_reader :room_id
    attr_accessor :is_reserved, :is_in_block

    def initialize(id, is_reserved, is_in_block: false)
      @room_id = id
      @is_reserved = is_reserved
      @is_in_block = is_in_block
    end

    def in_block
      return @is_in_block == true ? false : true
    end

    def reserved
      return @is_reserved == true ? false : true
    end

  end
end
