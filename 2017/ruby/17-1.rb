#!/usr/bin/env ruby

buffer = [0]
steps = 344
current_pos = 0

(1..2017).each do |i|
  new_pos = (current_pos + steps) % buffer.size
  current_pos = new_pos + 1
  buffer.insert(current_pos, i)
end

puts buffer[current_pos + 1]
