#!/usr/bin/env ruby

registers = {}
registers.default = 0
frequencies = []

instructions = ARGF.readlines.map(&:chomp)

i = 0

while i < instructions.length
  instruction = instructions[i]
  op, x, y = instruction.split

  if y
    y = if y.to_s =~ /^[a-z]$/
      registers[y]
    else
      y.to_i
    end
  end

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
    unless registers.fetch(x).zero?
      puts frequencies.last 
      return
    end
  when "jgz"
    if registers.fetch(x) > 0
      i += y 
      next
    end
  end

  i += 1
end

