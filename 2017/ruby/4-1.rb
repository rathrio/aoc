#!/usr/bin/env ruby

lines = ARGF.readlines

valid_line_count = 0

lines.each do |line|
  valid = true

  words = line.split
  words.each do |word|
    if words.count(word) > 1
      valid = false
      break
    end
  end

  valid_line_count += 1 if valid

  valid = true
end

puts valid_line_count
