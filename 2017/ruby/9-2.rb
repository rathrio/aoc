#!/usr/bin/env ruby

GARBAGE = /<((?!>)(!!|!>|[^>])*)?>/
puts ARGF.read.chomp.scan(GARBAGE).
  map { |match, _| match.to_s.gsub(/!./, '') }.
  sum(&:length)
