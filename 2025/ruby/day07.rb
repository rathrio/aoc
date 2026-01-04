require 'set'

def part1
  start, *rest = DATA.readlines.map(&:chomp)
  split_count = 0
  beam_indices = Set.new([start.index('S')])

  rest.each do |line|
    new_beam_indices = Set.new
    beam_indices.each do |i|
      char = line[i]
      case char
      when '.'
        new_beam_indices << i
      when '^'
        new_beam_indices << i - 1
        new_beam_indices << i + 1
        split_count += 1
      else
        raise "don't know what to do with #{char}"
      end
    end

    beam_indices = new_beam_indices
  end

  puts split_count
end

class Node
  attr_reader :children, :n

  def initialize(n)
    @n = n
    @children = []
  end

  def add_child(child)
    @children << child
  end

  def to_s
    @n
  end
end


def count_paths_dag(node, memo = {})
  return memo[node.n] if memo.key?(node.n)

  if node.children.empty?
    memo[node.n] = 1
    return 1
  end

  total_paths = node.children.sum { |child| count_paths_dag(child, memo) }
  memo[node.n] = total_paths
  total_paths
end

def part2
  start, *rest = DATA.readlines.map(&:chomp)
  beam_indices = Set.new([start.index('S')])
  root = "#{beam_indices.first}--1"
  nodes = {}
  nodes[root] = Node.new(root)

  rest.each_with_index do |line, row_index|
    new_beam_indices = Set.new
    beam_indices.each do |i|
      char = line[i]
      case char
      when '.'
        new_beam_indices << i

        child = Node.new("#{i}-#{row_index}")
        nodes["#{i}-#{row_index}"] = child
        nodes.fetch("#{i}-#{row_index - 1}").add_child(child)
      when '^'
        new_beam_indices << i - 1
        left_child = Node.new("#{i - 1}-#{row_index}")
        nodes["#{i - 1}-#{row_index}"] = left_child
        nodes.fetch("#{i}-#{row_index - 1}").add_child(left_child)

        new_beam_indices << i + 1
        right_child = Node.new("#{i + 1}-#{row_index}")
        nodes["#{i + 1}-#{row_index}"] = right_child
        nodes.fetch("#{i}-#{row_index - 1}").add_child(right_child)
      else
        raise "don't know what to do with #{char}"
      end
    end

    beam_indices = new_beam_indices
  end

  binding.irb
end

part2

__END__
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
