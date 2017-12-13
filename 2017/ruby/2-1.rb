#!/usr/bin/env ruby

input = ARGV[0]

puts input.split("\n").
  map { |l| l.split(/\s/).map(&:to_i) }.
  sum { |l| l.max - l.min }
