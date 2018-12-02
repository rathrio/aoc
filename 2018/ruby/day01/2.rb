#!/usr/bin/env ruby

frequency = 0
reached = { 0 => true }

File.readlines('input.txt').map(&:to_i).cycle do |change|
  frequency += change

  if reached[frequency]
    puts frequency
    exit
  end

  reached[frequency] = true
end
