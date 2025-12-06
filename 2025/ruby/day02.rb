def invalid?(id)
  id = id.to_s
  length = id.length
  return false if length.odd?

  id[0..((length / 2) - 1)] == id[(length / 2)..]
end

def invalid_part2(id)
  id = id.to_s
  longest_subsequence = String.new

  id.chars.each_with_index do |char, index|
  end
end

def part1
  sum = 0

  DATA.read.split(',').map(&:strip).reject(&:empty?).each do |range_str|
    x, y = range_str.split('-').map(&:to_i)
    range = x..y
    sum += range.select { |id| invalid?(id) }.sum
  end

  puts sum
end

part1

__END__
516015-668918,222165343-222281089,711089-830332,513438518-513569318,4-14,4375067701-4375204460,1490-3407,19488-40334,29275041-29310580,4082818-4162127,12919832-13067769,296-660,6595561-6725149,47-126,5426-11501,136030-293489,170-291,100883-121518,333790-431800,897713-983844,22-41,42727-76056,439729-495565,43918886-44100815,725-1388,9898963615-9899009366,91866251-91958073,36242515-36310763
