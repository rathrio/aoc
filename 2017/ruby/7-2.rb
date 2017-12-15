#!/usr/bin/env ruby

lines = ARGF.readlines.map(&:chomp)

$towers = {}

Tower = Struct.new(:name, :weight, :subtower_names, :parent) do
  def total_weight
    return weight if subtower_names.empty?
    weight + subtower_weights.sum
  end

  def subtower_weights
    subtower_names.map { |n| $towers.fetch(n).total_weight }
  end

  def subtowers
    subtower_names.map { |n| $towers.fetch(n) }
  end
end

lines.each do |line|
  left, right = line.split('->').map(&:strip)
  name, weight = left.scan(/(\w+)\s+\((\d+)\)/).flatten
  subtower_names = right.to_s.split(',').map(&:strip)
  $towers[name] ||= Tower.new(name, weight.to_i, subtower_names, nil)
end


all_towers = $towers.values
all_towers.each do |tower|
  tower.subtower_names.each do |sub|
    subtower = $towers.fetch(sub)
    subtower.parent = tower.name
  end
end

def fix_weight(tower)
  return 0 if tower.subtower_names.empty?
  return 0 if tower.subtower_weights.uniq.count == 1

  subtowers = tower.subtowers
  # todo: find the odd one out and trickle down
end

root = all_towers.find { |t| t.parent.nil? }

fix_weight(root)

puts
