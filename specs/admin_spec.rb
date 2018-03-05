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
    it "returns an array of Room instances" do
      initial_rooms = @admin.create_rooms
      initial_rooms.must_be_kind_of Array
      initial_rooms.all? {|room| room.must_be_instance_of Hotel::Room}
    end
  end

end
