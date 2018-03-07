module Hotel
  class Room

    attr_reader :is_reserved, :room_id

    def initialize(id)
      @is_reserved = true
      @room_id = id
    end

  end
end
