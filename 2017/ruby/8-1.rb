#!/usr/bin/env ruby

lines = ARGF.readlines.map(&:chomp)
vars = {}

class Var
  attr_reader :v

  def initialize
    @v = 0
  end

  def inc(value)
    @v += value
  end

  def dec(value)
    @v -= value
  end

  def ==(other)
    @v == other
  end

  def method_missing(*args)
    @v.send(*args)
  end
end

lines.each do |line|
  line.sub!(/([a-z]+)\s/, "\\1\.")
  var = $1
  vars[var] ||= Var.new
end

vars.keys.each do |var|
  define_method(var) { vars.fetch(var) }
end

eval lines.join("\n")
puts vars.values.map(&:v).max
