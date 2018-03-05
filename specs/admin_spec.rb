require_relative 'spec_helper'

describe "Admin class" do

  before do
    @admin = Hotel::Admin.new
  end

  describe "Initializer" do
    it "is an instance of Admin" do
      @admin.must_be_instance_of Hotel::Admin
    end

    it "creates initial data structures" do
      @admin.reservations.must_be_kind_of Array
      @admin.num_rooms.must_be_kind_of Integer
      @admin.rooms.must_be_kind_of Array
    end
  end

  describe "#create_rooms" do
    before do
      @initial_rooms = @admin.create_rooms
    end

    it "returns an array of Room instances" do
      @initial_rooms.must_be_kind_of Array
      @initial_rooms.all? {|room| room.must_be_instance_of Hotel::Room}
    end

    it "assigns correct ids to Room instances" do
      @initial_rooms.first.room_id.must_equal 1
      @initial_rooms.last.room_id.must_equal 20
    end
  end

  describe "#create_room_instance" do
    it "returns a Room instance" do
      id = 1
      @admin.create_room_instance(id).must_be_instance_of Hotel::Room
    end
  end

end
