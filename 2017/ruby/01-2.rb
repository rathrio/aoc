#!/usr/bin/env ruby

digits = ARGV[0]

size = digits.length
half = size / 2

sum = 0

digits.each_char.with_index do |digit, index|
  digit = digit.to_i
  digit_halfway_around = digits[(index + half) % size].to_i

  if digit == digit_halfway_around
    sum += digit
  end
end

puts sum
