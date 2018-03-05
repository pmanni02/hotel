module Hotel
  class Room

    attr_reader :is_reserved, :room_id

    def initialize(id)
      @is_reserved = false
      @room_id = id
    end

  end
end
