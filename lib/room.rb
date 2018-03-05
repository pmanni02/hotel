module Hotel
  class Room

    attr_reader :is_reserved, :room_id

    def initialize(id)
      @is_reserved = FALSE
      @room_id = id
    end

  end
end
