#!/usr/bin/env ruby

n = ARGV[0].to_i

# @param n [Integer] which circle in the spiral
# @return [Integer] number of squares in n-th circle
def squares(n)
  return 1 if n == 1
  width = n + 2 if n > 1

  (2 * width) + (2 * (width + 2))
end

puts squares(n)
