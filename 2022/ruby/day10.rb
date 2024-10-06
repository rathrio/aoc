cycle = 0
x = 1

def compile
  instructions = []

  DATA.readlines.each do |line|
    case line.chomp.split(" ")
    in ["addx", v]
      instructions.push(["noop"])
      instructions.push(["addx", v.to_i])
    in ["noop"]
      instructions.push(["noop"])
    else
      raise "unsupported instruction: #{line}"
    end
  end

  instructions
end

def sample_strength(samples, x, cycle)
  if cycle == 20 || ((cycle - 20) % 40).zero?
    samples << (cycle * x)
  end
end

def part1
  instructions = compile

  cycle = 1
  x = 1
  samples = []
  instructions.each do |i|
    sample_strength(samples, x, cycle)

    case i
    in ["addx", v]
      x += v
    in ["noop"]
    else
      raise "unsupported instruction: #{i}"
    end

    cycle += 1
  end

  puts samples.sum
end

def part2
  instructions = compile
  crt = ""

  cycle = 1
  x = 1

  instructions.each do |i|
    position = (cycle - 1) % 40

    sprite = Set.new([x - 1, x, x + 1])
    sprite.include?(position) ? crt << "#" : crt << "."

    crt << "\n" if cycle % 40 == 0

    case i
    in ["addx", v]
      x += v
    in ["noop"]
    else
      raise "unsupported instruction: #{i}"
    end

    cycle += 1
  end

  puts crt
end

part2


__END__
addx 1
noop
addx 2
noop
addx 3
addx 3
addx 1
addx 5
addx 1
noop
noop
addx 4
noop
noop
addx -9
addx 16
addx -1
noop
addx 5
addx -2
addx 4
addx -35
addx 2
addx 28
noop
addx -23
addx 3
addx -2
addx 2
addx 5
addx -8
addx 19
addx -8
addx 2
addx 5
addx 5
addx -14
addx 12
addx 2
addx 5
addx 2
addx -13
addx -23
noop
addx 1
addx 5
addx -1
addx 2
addx 4
addx -9
addx 10
noop
addx 6
addx -11
addx 12
addx 5
addx -25
addx 30
addx -2
addx 2
addx -5
addx 12
addx -37
noop
noop
noop
addx 24
addx -17
noop
addx 33
addx -32
addx 3
addx 1
noop
addx 6
addx -13
addx 17
noop
noop
noop
addx 12
addx -4
addx -2
addx 2
addx 3
addx 4
addx -35
addx -2
noop
addx 20
addx -13
addx -2
addx 5
addx 2
addx 23
addx -18
addx -2
addx 17
addx -10
addx 17
noop
addx -12
addx 3
addx -2
addx 2
noop
addx 3
addx 2
noop
addx -13
addx -20
noop
addx 1
addx 2
addx 5
addx 2
addx 5
noop
noop
noop
noop
noop
addx 1
addx 2
addx -18
noop
addx 26
addx -1
addx 6
noop
noop
noop
addx 4
addx 1
noop
noop
noop
noop
