#!/usr/bin/env ruby

steps = 344
current_pos = 0
result = nil

(1..50_000_000).each do |i|
  new_pos = (current_pos + steps) % i
  current_pos = new_pos + 1
  result = i if current_pos == 1
end

puts result
