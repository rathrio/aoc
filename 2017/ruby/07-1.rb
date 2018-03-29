#!/usr/bin/env ruby

lines = ARGF.readlines.map(&:chomp)
Tower = Struct.new(:name, :weight, :subtower_names, :parent)
towers = {}

lines.each do |line|
  left, right = line.split('->').map(&:strip)
  name, weight = left.scan(/(\w+)\s+\((\d+)\)/).flatten
  subtower_names = right.to_s.split(',').map(&:strip)
  towers[name] ||= Tower.new(name, weight, subtower_names, nil)
end


all_towers = towers.values
all_towers.each do |tower|
  tower.subtower_names.each do |sub|
    subtower = towers.fetch(sub)
    subtower.parent = tower.name
  end
end

puts all_towers.find { |t| t.parent.nil? }.name
