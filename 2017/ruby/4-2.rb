#!/usr/bin/env ruby

class String
  def anagram_of?(other)
    chars.sort == other.chars.sort
  end
end

lines = ARGF.readlines
valid_line_count = 0

lines.each do |line|
  valid = true

  words = line.split
  words.each do |word|
    if (words - [word]).any? { |w| w.anagram_of?(word) }
      valid = false
      break
    end
  end

  valid_line_count += 1 if valid
end

puts valid_line_count
