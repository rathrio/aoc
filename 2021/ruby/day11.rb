require 'set'

class Integer
  def to_nil_if_negative
    return nil if self < 0
    self
  end
end

class Array
  def at(coordinates)
    return nil if coordinates.any?(&:nil?)

    dig(*coordinates)
  end

  def print
    puts map(&:join)
  end

  def neighbor_coords(row_index, col_index)
    [
      [row_index - 1, col_index].map(&:to_nil_if_negative),     # top
      [row_index - 1, col_index - 1].map(&:to_nil_if_negative), # topleft
      [row_index, col_index - 1].map(&:to_nil_if_negative),     # left
      [row_index + 1, col_index - 1].map(&:to_nil_if_negative), # bottomleft
      [row_index + 1, col_index].map(&:to_nil_if_negative),     # bottom
      [row_index + 1, col_index + 1].map(&:to_nil_if_negative), # bottomright
      [row_index, col_index + 1].map(&:to_nil_if_negative),     # right
      [row_index - 1, col_index + 1].map(&:to_nil_if_negative)  # topright
    ]
  end
end

GRID = DATA.readlines.map { |line| line.chomp.split('').map(&:to_i) }

def step(row_index, col_index, flashed = Set.new)
  level = GRID.at([row_index, col_index])
  return if level.nil?

  level += 1
  GRID[row_index][col_index] = level

  return if level <= 9 || flashed.include?([row_index, col_index])
  flashed << [row_index, col_index]

  neighbor_coords = GRID.neighbor_coords(row_index, col_index)
  neighbor_coords.each do |(r, c)|
    step(r, c, flashed)
  end
end

def part1
  num_flashes = 0

  100.times do |i|
    flashed = Set.new

    GRID.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        step(row_index, col_index, flashed)
      end
    end

    flashed.each do |(row_index, col_index)|
      GRID[row_index][col_index] = 0
    end

    num_flashes += flashed.size
  end

  puts num_flashes
end


def part2
  expected_num_flashes = GRID.size * GRID.first.size

  (0..).each do |i|
    flashed = Set.new

    GRID.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        step(row_index, col_index, flashed)
      end
    end

    flashed.each do |(row_index, col_index)|
      GRID[row_index][col_index] = 0
    end

    if flashed.size == expected_num_flashes
      puts i + 1
      break
    end
  end
end

part2

__END__
2238518614
4552388553
2562121143
2666685337
7575518784
3572534871
8411718283
7742668385
1235133231
2546165345
