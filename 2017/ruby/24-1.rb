#!/usr/bin/env ruby

components = ARGF.readlines.map(&:chomp).map { |c| c.split("/").map(&:to_i) }
$nodes = []

class Node
  attr_accessor :parent
  attr_reader :component, :component_strength

  def initialize(component = [0, 0])
    @component = component
    @component_strength = component.sum
  end

  def right_pin
    component[1]
  end

  def nodes
    @nodes ||= []
  end

  def connect(components)
    components.select { |c| c.include? right_pin }.each do |c|
      n = Node.new(c[1] == right_pin ? c.reverse : c)
      nodes << n
      $nodes << n
      n.parent = self
      n.connect(components - [c])
    end
  end

  def leaf?
    nodes.empty?
  end

  def strength
    component_strength + parent&.strength.to_i
  end
end

Node.new.connect(components)
puts $nodes.select(&:leaf?).map(&:strength).max
