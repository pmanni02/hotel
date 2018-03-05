require_relative 'reservation'
require_relative 'room'

module Hotel
  class Admin

    attr_reader :reservations, :rooms

    def initialize
      @reservations = []
      @rooms = []
    end

  end
end
