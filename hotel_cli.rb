require 'pry'

require_relative 'lib/admin'
require_relative 'lib/reservation'
require_relative 'lib/room'

HOTEL = Hotel::Admin.new

def display_options
  puts
  puts "----------------- OPTIONS ----------------"
  puts "SHOW all reservations - reservations OR 1"
  puts "ADD reservation - add reservation OR 2"
  puts "ADD block - add block OR 3"
  puts "To exit this program - exit"
  puts "------------------------------------------"
  puts "OPTION: "
  puts
end

def show_rooms(rooms)
  i = 0
  while i < rooms.length
    print "\nRoom ID: #{rooms[i].room_id} | "
    print "Reserved?: #{rooms[i].is_reserved.to_s} | "
    print "In block?: #{rooms[i].is_in_block.to_s}"
    i += 1
  end
  puts
end

def show_reservations(reservations)
  if reservations.length == 0
    puts "\nThere are no current reservations."
  else
    i = 0
    while i < reservations.length
      print "\nRoom ID: #{reservations[i].room.room_id} | "
      print "Start Date: #{reservations[i].start_date} | "
      print "End Date: #{reservations[i].end_date} | "
      print "Cost per night: #{reservations[i].cost_per_night} | "
      print "Total Cost: #{reservations[i].total_cost}"
      i += 1
    end
    puts
  end
end

def valid_input_loop(pattern)
  input = gets.chomp
  while !pattern.match(input)
    puts "Please enter info in the valid format."
    input = gets.chomp
  end
  return input
end

def get_date_range
  pattern = /^\d{4}\-\d{2}\-\d{2}$/
  valid_date = false
  until valid_date == true
    date_range = {}
    puts "Please enter start date in the following format -> yyyy-mm-dd: "
    start_date_input = valid_input_loop(pattern)
    start_date = Date.strptime( start_date_input, '%Y-%m-%d')
    date_range[:start_date] = start_date
    puts "Please enter end date in the following format -> yyyy-mm-dd: "
    end_date_input = valid_input_loop(pattern)
    end_date = Date.strptime( end_date_input, '%Y-%m-%d')
    date_range[:end_date] = end_date
    if HOTEL.check_date_range(date_range)
      valid_date = true
    else
      puts "Invalid date range - try again"
    end
  end
  return date_range
end

def show_available_rooms(date_range)
  puts "\nThe following rooms are available for reservation: "
  available_rooms = HOTEL.get_unreserved_rooms(date_range)
  available_rooms.each do |room|
    print "#{room} | "
  end
  puts
  return available_rooms
end

def show_reservation(reservation)
  puts " - Start Date: #{reservation.start_date}"
  puts " - End Date: #{reservation.end_date}"
  puts " - Room ID: #{reservation.room.room_id}"
  puts
end

def get_reservation
  date_range = get_date_range
  available_rooms = show_available_rooms(date_range)

  puts "\nPlease enter an available room ID"
  pattern = /^[1-9]{1}[0-9]{0,1}$/
  room_id = valid_input_loop(pattern).to_i
  until room_id <= HOTEL.num_rooms && room_id > 0 && available_rooms.include?(room_id)
    puts "\nInvalid room ID"
    show_available_rooms(date_range)
    room_id = valid_input_loop(pattern).to_i
  end

  return HOTEL.add_reservation(date_range, room_id)
end

def show_block(block)
  puts " - Start Date: #{block[:start_date]}"
  puts " - End Date: #{block[:end_date]}"
  puts " - Rooms: "
  rooms = block[:rooms]
  rooms.each do |room|
    print "#{room.room_id} | "
  end
  puts " - Cost/Night: $#{block[:room_rate]}"
end

def get_block
  date_range = get_date_range
  # available_rooms = show_available_rooms(date_range)
  puts "\nPlease enter # of rooms in block [1-5]."
  pattern = /^[1-5]{1}/
  num_rooms = valid_input_loop(pattern).to_i
  return HOTEL.make_block(date_range, num_rooms)
end

puts "Welcome to [insert name here] Hotel!"
puts "\n--------------- HOTEL INFO ---------------"
puts "Number of rooms: #{HOTEL.num_rooms}"
puts "Base room rate: #{HOTEL.base_rate}"
puts "Discount rate/room for block reservation: #{HOTEL.discount_rate * 100}%"
puts

display_options
command = gets.chomp

while command != "exit"
  if command == "reservations" || command == "1"
    show_reservations(HOTEL.reservations)
  elsif command == "add reservation" || command == "2"
    reservation = get_reservation
    puts "\nReservation Complete!"
    show_reservation(reservation)
  elsif command == "add block" || command == "3"
    block = get_block
    puts "\nBlock Complete!"
    show_block(block)
  else
    puts "Please enter a valid command."
  end
  puts
  display_options
  command = gets.chomp
end
