#!/usr/bin/env ruby

require 'thread'

class Program
  def initialize(id, receive:, send:)
    @id = id
    @receive = receive
    @send = send
    @registers = { 'p' => @id }
    @registers.default = 0
    @send_count = 0
  end

  def run(instructions)
    Thread.new do
      i = 0

      while i < instructions.length
        instruction = instructions[i]
        op, x, y = instruction.split

        if y
          y = if y.to_s =~ /^[a-z]$/
                @registers[y]
              else
                y.to_i
              end
        end

        case op
        when "snd"
          x = (x.to_s =~ /^[a-z]$/) ? @registers.fetch(x) : x.to_i
          @send << x
          @send_count += 1
          puts @send_count if @id == 1
        when "set"
          @registers[x] = y
        when "add"
          @registers[x] += y
        when "mul"
          @registers[x] *= y
        when "mod"
          @registers[x] %= y
        when "rcv"
          @registers[x] = @receive.pop
        when "jgz"
          x = (x.to_s =~ /^[a-z]$/) ? @registers.fetch(x) : x.to_i
          if x > 0
            i += y 
            next
          end
        end

        i += 1
      end
    end
  end
end

instructions = ARGF.readlines.map(&:chomp)

p0_receive_queue = Queue.new
p1_receive_queue = Queue.new

p0 = Program.new(
  0,
  receive: p0_receive_queue,
  send: p1_receive_queue
).run(instructions)

p1 = Program.new(
  1,
  receive: p1_receive_queue,
  send: p0_receive_queue
).run(instructions)

begin
  p0.join
  p1.join
rescue Exception
  exit
end
