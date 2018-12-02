#!/usr/bin/env ruby

puts File.readlines('input.txt').map(&:to_i).sum
