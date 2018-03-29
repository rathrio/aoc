#!/usr/bin/env ruby

instructions = ARGF.readlines.map(&:to_i)
max_index = instructions.size - 1
index = 0
jumps = 0

while index.between?(0, max_index)
  instruction = instructions[index]
  index_before_jump = index
  index += instruction

  offset = (instruction >= 3) ? -1 : 1
  instructions[index_before_jump] = instruction + offset
  jumps += 1
end

puts jumps
