#!/usr/bin/env ruby

registers = ('a'..'h').map { |r| [r, 0] }.to_h
frequencies = []

instructions = ARGF.readlines.map(&:chomp)

i = 0

mul_invoked = 0

while i < instructions.length
  instruction = instructions[i]
  op, x, y = instruction.split
  y = (y.to_s =~ /^[a-z]$/) ? registers[y] : y.to_i

  case op
  when "set"
    registers[x] = y
  when "sub"
    registers[x] -= y
  when "mul"
    registers[x] *= y
    mul_invoked += 1
  when "jnz"
    x = (x.to_s =~ /^[a-z]$/) ? registers[x] : x.to_i
    unless x.zero?
      i += y 
      next
    end
  end

  i += 1
end

puts mul_invoked
