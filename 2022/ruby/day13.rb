pairs = DATA.read.split("\n\n").map do |pair|
  pair.split.map { |packet| eval packet }
end

pairs.each_with_index do |pair, i|
  # index as defined in the puzzle
  index = i + 1
  left, right = pair
  left.zip(right).each do |data|
    case data
    in [Integer, Integer]
    in [Array, Array]
    in [Array, Integer]
    in [Integer, Array]
    in [_, nil]
    in [nil, _]
    else
      raise "unrecognized pattern: #{data}"
    end
  end
end

__END__
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
