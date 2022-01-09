require 'set'

class Integer
  def to_nil_if_negative
    return nil if self < 0
    self
  end
end

class Array
  def start
    [0, 0]
  end

  def start?(c)
    c == start
  end

  def destination
    [size - 1, first.size - 1]
  end

  def destination?(c)
    c == destination
  end

  def at(coordinates)
    return nil if coordinates.any?(&:nil?)

    dig(*coordinates)
  end

  def print
    puts map(&:join)
  end

  def neighbor_coords(row_index, col_index)
    [
      [row_index - 1, col_index].map(&:to_nil_if_negative),
      [row_index, col_index - 1].map(&:to_nil_if_negative),
      [row_index + 1, col_index].map(&:to_nil_if_negative),
      [row_index, col_index + 1].map(&:to_nil_if_negative)
    ]
  end
end

GRID = DATA
  .readlines
  .map(&:chomp)
  .map { |line| line.split('').map(&:to_i) }



def update_cost_map(start, cost_map)
  neighbor_coords = cost_map.neighbor_coords(*start)
  neighbor_coords.each do |c|
    current_cost = cost_map.at(c)
    next if current_cost.nil?

    cost = cost_map.at(start) + GRID.at(c)
    next if cost >= current_cost

    cost_map[c[0]][c[1]] = cost
    update_cost_map(c, cost_map)

    return if cost_map.destination?(c)
  end
end

def part1
  start = GRID.start

  cost_map = Array.new(GRID.size) { Array.new(GRID.first.size) { 1000 } }
  cost_map[0][0] = 0
  update_cost_map(start, cost_map)
  puts cost_map.at(cost_map.destination)
end

def part2

end


__END__
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
