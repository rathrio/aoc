#!/usr/bin/env ruby

registers = {}
frequencies = []

instructions = ARGF.readlines.map(&:chomp)

for i in (0..instructions.length - 1)
  instruction = instructions[i]
  op, x, y = instruction.split
  y = y.to_i if y

  case op
  when "snd"
    frequencies << registers.fetch(x)
  when "set"
    registers[x] = y
  when "add"
    registers[x] += y
  when "mul"
    registers[x] *= y
  when "mod"
    registers[x] %= y
  when "rcv"
    puts frequencies.last unless registers.fetch(x).zero?
  when "jgz"
    i += y if registers.fetch(x) > 0
  end
end

