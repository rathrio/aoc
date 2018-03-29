#!/usr/bin/env ruby

lines = ARGF.readlines.map(&:chomp)

$towers = {}

Tower = Struct.new(:name, :weight, :subtower_names, :parent) do
  def total_weight
    return weight if subtower_names.empty?
    weight + subtowers.sum(&:total_weight)
  end

  def subtower_weights
    subtower_names.map { |n| $towers.fetch(n).weight }
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

def weight_to_fix(tower, diff)
  tower.subtowers.each_cons(2) do |t1, t2|
    next if t1.total_weight == t2.total_weight

    if t1.subtower_weights.uniq
    end

    break
  end
end

root = all_towers.find { |t| t.parent.nil? }
w1, w2 = root.subtowers.map(&:total_weight).uniq.sort.reverse
diff = w1 - w2
puts weight_to_fix(root, diff)
