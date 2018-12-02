#!/usr/bin/env ruby

counts = { 2 => 0, 3 => 0 }

File.readlines('input.txt').each do |line|
  line = line.chomp

  [2, 3].each do |n|
    counts[n] += 1 if line.chars.find { |c| line.count(c) == n }
  end
end

puts counts[2] * counts[3]
