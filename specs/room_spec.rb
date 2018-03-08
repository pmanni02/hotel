require_relative 'spec_helper'

describe "Room Class" do
  before do
    id = 1
    is_reserved = false
    @room = Hotel::Room.new(id, is_reserved)
  end

  describe "Initializer" do
    it "is an instance of Room" do
      @room.must_be_instance_of Hotel::Room
    end

    it "creates initial data structures" do
      @room.is_reserved.must_equal false
      @room.room_id.must_be_kind_of Integer
    end
  end
end
