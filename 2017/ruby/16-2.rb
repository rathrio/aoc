#!/usr/bin/env ruby

input = ARGF.read.chomp
programs = ('a'..'p').to_a
moves = input.split(',')

def s(move, programs)
  i = 16 - move.to_i
  to_move = programs.slice!(i..-1)
  programs.unshift(*to_move)
end

def x(move, programs)
  i, j = move.split('/').map(&:to_i)
  p_i = programs[i]
  p_j = programs[j]
  programs[i] = p_j
  programs[j] = p_i
end

def p(move, programs)
  p_i, p_j = move.split('/')
  i = programs.index(p_i)
  j = programs.index(p_j)
  programs[i] = p_j
  programs[j] = p_i
end

# Pattern starts repeating every 36th round. So we only have to iterate
# (1000000000 - ((1000000000 / 36) * 36)) times.
28.times do |i|
  round = i + 1

  moves.each do |move|
    case move
    when /^s/
      s(move[1..-1], programs)
    when /^x/
      x(move[1..-1], programs)
    when /^p/
      p(move[1..-1], programs)
    end
  end
end

puts programs.join
