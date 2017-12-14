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
  words.each_with_index do |word, index|
    tmp = words.clone
    tmp[index] = nil
    if tmp.compact.any? { |w| w.anagram_of?(word) }
      valid = false
      break
    end
  end

  valid_line_count += 1 if valid
end

puts valid_line_count
