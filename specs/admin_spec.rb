require_relative 'spec_helper'

describe "Admin class" do

  describe "Initializer" do
    before do
      @admin = Hotel::Admin.new
    end

    it "is an instance of Admin" do
      @admin.must_be_instance_of Hotel::Admin
    end

    it "creates initial data structures" do
      @admin.reservations.must_be_kind_of Array
      @admin.rooms.must_be_kind_of Array
    end
  end

end
