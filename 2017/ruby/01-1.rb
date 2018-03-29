#!/usr/bin/env ruby

digits = ARGV[0]

sum = 0
digits.chars.each_cons(2) { |d1, d2| sum += d1.to_i if d1 == d2 }

first = digits[0]
last = digits[-1]

if last == first
  sum += last.to_i
end

puts sum
