#!/usr/bin/env ruby

lines = File.readlines('input.txt').map(&:chomp)

lines.combination(2).each do |(w1, w2)|
  char_pairs = w1.chars.zip(w2.chars)
  edit_cost = char_pairs.map { |(c1, c2)| c1 == c2 ? 0 : 1 }.sum

  if edit_cost == 1
    puts char_pairs.select { |(c1, c2)| c1 == c2 }.map(&:first).join
    exit
  end
end
