#!/usr/bin/env ruby

class Generator
  include Enumerable
  X = 2147483647

  def initialize(factor, init, m)
    @factor = factor
    @current = init
    @m = m
  end

  def each
    loop do
      @current = @current * @factor % X
      yield @current if @current % @m == 0
    end
  end
end

class Judge
  include Enumerable

  def initialize(genA, genB)
    @a = genA
    @b = genB
    @matches = 0
  end

  def each
    loop do
      a = @a.first.to_s(2)[-16..-1]
      b = @b.first.to_s(2)[-16..-1]

      if a == b
        @matches += 1
      end

      yield @matches
    end
  end
end

A = Generator.new(16807, 516, 4)
B = Generator.new(48271, 190, 8)
judge = Judge.new(A, B)
puts judge.take(5_000_000).last
