#!/usr/bin/env ruby

input = ARGV[0]

puts input.split("\n").
  map { |l| l.split(/\s/).map(&:to_i) }.
  sum { |l| x, y = l.sort.reverse.combination(2).find { |a, b| a % b == 0 }
            x / y }
