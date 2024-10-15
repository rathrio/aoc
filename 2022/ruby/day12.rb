CHAR_TO_HEIGHT = ("a".."z").map.with_index { |c, i| [c, i] }.to_h

def height(char, char_to_height = CHAR_TO_HEIGHT)
  return char_to_height.fetch("a") if char == "S"
  return char_to_height.fetch("z") if char == "E"

  char_to_height.fetch(char)
end

def print_grid(grid)
  out = ""
  grid.each do |row|
    out << row.map { |c| c == Float::INFINITY ? " ∞ " : c.to_s.rjust(3, " ") }.join
    out << "\n"
  end
  puts "\e[H\e[2J#{out}"
end

def neighbor_positions(row_index, col_index, max_row_index, max_col_index)
  [
    [row_index, col_index - 1], # left
    [row_index, col_index + 1], # right
    [row_index - 1, col_index], # top
    [row_index + 1, col_index], # bottom
  ].reject { |row, col| row < 0 || col < 0 || row > max_row_index || col > max_col_index }
end

def part1
  lines = DATA.readlines.map(&:chomp)
  heightmap = lines.map { |line| line.chars.map { 0 } }
  stepmap = lines.map { |line| line.chars.map { Float::INFINITY } }

  start_pos = nil
  end_pos = nil

  lines.each_with_index do |line, row_index|
    line.chars.each_with_index do |char, col_index|
      heightmap[row_index][col_index] = height(char)
      start_pos = [row_index, col_index] if char == "S"
      end_pos = [row_index, col_index] if char == "E"
    end
  end

  start_row, start_col = start_pos
  stepmap[start_row][start_col] = 0

  max_row_index = lines.length - 1
  max_col_index = lines.first.length - 1

  visited = Set.new
  positions = [start_pos]

  while current_pos = positions.shift
    neighbor_positions(*current_pos, max_row_index, max_col_index).each do |pos|
      next if visited.include? pos

      current_height = heightmap.dig(*current_pos)
      current_steps = stepmap.dig(*current_pos)

      height = heightmap.dig(*pos)
      steps = stepmap.dig(*pos)

      if height - current_height <= 1 && steps > current_steps
        row, col = pos
        stepmap[row][col] = current_steps + 1

        positions << pos
        visited << pos
      else
        # bail
      end
    end
  end

  puts stepmap.dig(*end_pos)
end

def part2
  lines = DATA.readlines.map(&:chomp)
  heightmap = lines.map { |line| line.chars.map { 0 } }
  stepmap = lines.map { |line| line.chars.map { Float::INFINITY } }

  start_pos = nil
  end_pos = nil

  lines.each_with_index do |line, row_index|
    line.chars.each_with_index do |char, col_index|
      heightmap[row_index][col_index] = height(
        char,
        ("a".."z").to_a.reverse.map.with_index { |c, i| [c, i] }.to_h
      )

      start_pos = [row_index, col_index] if char == "S"
      end_pos = [row_index, col_index] if char == "E"
    end
  end

  start_row, start_col = end_pos
  stepmap[start_row][start_col] = 0

  max_row_index = lines.length - 1
  max_col_index = lines.first.length - 1

  visited = Set.new
  positions = [end_pos]

  while current_pos = positions.shift
    neighbor_positions(*current_pos, max_row_index, max_col_index).each do |pos|
      next if visited.include? pos

      current_height = heightmap.dig(*current_pos)
      current_steps = stepmap.dig(*current_pos)

      height = heightmap.dig(*pos)
      steps = stepmap.dig(*pos)

      if height - current_height <= 1 && steps > current_steps
        row, col = pos
        stepmap[row][col] = current_steps + 1

        positions << pos
        visited << pos
      else
        # bail
      end
    end
  end

  min_steps = Float::INFINITY
  heightmap.each_with_index do |row, row_i|
    row.each_with_index do |col, col_i|
      next unless col == 25
      min_steps = [min_steps, stepmap[row_i][col_i]].min
    end
  end

  puts min_steps
end

part2

__END__
abcccccccccccccccccccccccccccccccaaaaaaaaaaaaaaaaccaaaaaaaaccccccccccccccccccccccccccccccccccccaaaaaa
abcccccccccccccccccccccccccccccccaaaaaaaaaaaaaaaaaccaaaaaaccccccccccccccccccccccccccccccccccccccaaaaa
abcccccccccccccccccccccccccccccccccaaaaaaaacccaaaaccaaaaaaccccccccccccccccccccaaaccccccccccccccccaaaa
abcccccccccccccccccccccccccccccccccccaaaaaaaccaaccccaaaaaaccccccccccccccccccccaaaccccccccccccccccaaaa
abcccccccccccccccccccccccccccccaaacccaaaaaaaacccccccaaccaaccccccccccccccccccccaaaccccccccccccccccaaac
abcccccccccccccccccccccccccccccaaaaaaaaacaaaacccccccccccccccaccaaccccccccccccciiaaccaaaccccccccccaacc
abccccccccaaccccccccccccccccccaaaaaaaaaaccaaacccccccccccccccaaaaaccccccccacaiiiiijjaaaacccccccccccccc
abacccaaccaacccccccccccccccccaaaaaaaaaaccccacccccaaaaccccccccaaaaacccccccaaiiiiijjjjaaaccccccaacccccc
abacccaaaaaacccccccccccccccccaaaaaaaaccccccccccccaaaacccccccaaaaaacccccccaiiiioojjjjjacccaaaaaacccccc
abcccccaaaaaaacccccccccccccccccaaaaaaccccaaccccccaaaacccccccaaaaccccccccciiinnoooojjjjcccaaaaaaaccccc
abccccccaaaaaccccccccccccccccccaaaaaacccaaaaccccccaaacccccccccaaaccccccchiinnnooooojjjjcccaaaaaaacccc
abcccccaaaaacccccccccccccccccccaacccccccaaaaccccccccccccccccccccccccccchhiinnnuuoooojjjjkcaaaaaaacccc
abccccaaacaaccccccccccccccccccccccccccccaaaaccccccccccccccccccaaacccchhhhhnnntuuuoooojjkkkkaaaacccccc
abccccccccaacccccccccccccccccccccccccccccccccccccccccccccccccccaacchhhhhhnnnnttuuuuoookkkkkkkaacccccc
abcccccccccccccccccccaacaaccccccccccccccccccccccccccccccccccaacaahhhhhhnnnnntttxuuuoopppppkkkkacccccc
abcccccccccccccccccccaaaaacccccccccaccccccccccccccccccccccccaaaaahhhhmnnnnntttxxxuuupppppppkkkccccccc
abccccccccccccccccccccaaaaacccccaaaacccccccccccccccccccccccccaaaghhhmmmmttttttxxxxuuuuuupppkkkccccccc
abcccccccccccccccccccaaaaaaaccccaaaaaaccccccccccccccccccccccccaagggmmmmtttttttxxxxuuuuuuvppkkkccccccc
abcccccccccccccccccccaaaaaaaaaaacaaaaacccccccccccccccccccccccaaagggmmmttttxxxxxxxyyyyyvvvppkkkccccccc
abccccccccccccccccccccaaaaaaaaaaaaaaaccccccccccccccccccccaacaaaagggmmmtttxxxxxxxyyyyyyvvppplllccccccc
SbcccccccccccccccccccaaaaaaaaaacaccaaccccccccccccccccccccaaaaaccgggmmmsssxxxxEzzzyyyyvvvpplllcccccccc
abcccccccccccccccccccccaaaaaaccccccccccccccaacaaccccccccaaaaaccccgggmmmsssxxxxyyyyyvvvvqqplllcccccccc
abccccccccccccccccccccccaaaaaacccccccccccccaaaacccccccccaaaaaacccgggmmmmsssswwyyyyyvvvqqqlllccccccccc
abcccccccccccccccccccccaaaaaaaccccccccccccaaaaacccccccccccaaaaccccgggmmmmsswwyyyyyyyvvqqllllccccccccc
abcccccccccccccccccccccaaaccaaacccccccccccaaaaaaccccccccccaccccccccgggooosswwwywwyyyvvqqlllcccccccccc
abccccccccccccccccccccccacccccccccccccccccacaaaacccccccccccccccccccfffooosswwwwwwwwvvvqqqllcccccccccc
abccccccccccccccccccccccccccccccccccccccccccaacccccccccccccccccccccfffooosswwwwwrwwvvvqqqllcccccccccc
abccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccffooossswwwrrrwvvvqqqmmcccccccccc
abccccaaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccffooosssrrrrrrrrqqqqmmmcccccccccc
abccccaaacaacccccaaccccaaaacccccccccccccccccccccccccccccccccccccccccffooossrrrrrnrrrqqqqmmmcccaaacccc
abcccccaaaaaccaaaaacccaaaaacccccccccccccccccccccccccccccccccccccccccfffoooorrnnnnnnmqqmmmmmcccaaacccc
abccaaaaaaaacccaaaaaccaaaaaaccccccccccccccccccccccccccccccccccccccccfffooonnnnnnnnnmmmmmmmcccaaaccccc
abcccaaaaacccccaaaaaccaaaaaaccccccaacccccccccccccccccccccccccccccccccfffoonnnnneddnmmmmmmccccaaaccccc
abccccaaaaacccaaaaacccaaaaaacccccaaaaaaccccccccccccccccccccaaccccccccffeeeeeeeeeddddddddccccaaaaccccc
abccccaacaaacccccaacccccaacccccccaaaaaaaccccccccccccccccaaaaaccccccccceeeeeeeeeedddddddddccaccaaccccc
abccccaacccccccccccccccccccccccccaaaaaaaccaaaccccccccccccaaaaaccccccccceeeeeeeeaaaaddddddcccccccccccc
abcccccccccccaaccccccccccccccccccccccaaaaaaaaacccccccccccaaaaacccccccccccccaaaacaaaacccccccccccccccaa
abccccccccaacaaacccccccccccccccccccccaaaaaaaacccccccccccaaaaaccccccccccccccaaaccaaaaccccccccccccccaaa
abccccccccaaaaacccccccccccccccccccccacaaaaaaccccccccccccccaaacccccccccccccccaccccaaacccccccccccacaaaa
abcccccccccaaaaaaccccccccccccccccaaaaaaaaaaacccccccccccccccccccccccccccccccccccccccacccccccccccaaaaaa
abcccccccaaaaaaaaccccccccccccccccaaaaaaaaaaaaacccccccccccccccccccccccccccccccccccccccccccccccccaaaaaa
