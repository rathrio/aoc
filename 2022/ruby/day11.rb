class Monkey
  attr_accessor :id, :items, :operation, :test, :if_true_monkey, :if_false_monkey
  attr_reader :num_inspections

  def initialize(id)
    @id = id
    @num_inspections = 0
  end

  def test?(worry_level)
    worry_level % prime == 0
  end

  def prime
    @prime ||= test.split.last.to_i
  end

  def receive(item)
    @items << item
  end

  def inspect_item(item)
    old = item
    @num_inspections += 1
    eval @operation
  end

  def multiplies?
    @multiplies ||= @operation.include?("*")
  end

  def adds?
    @adds ||= @operation.include?("+")
  end
end

def parse_monkeys
  monkeys = []
  current_monkey = nil

  DATA.readlines.each do |line|
    line = line.strip
    next if line.empty?

    case line
    when /^Monkey\s*(\d+):/
      monkeys << current_monkey if current_monkey

      current_monkey = Monkey.new($1)
    when /^Starting items:\s*(.+)/
      current_monkey.items = $1.split(',').map(&:to_i)
    when /^Operation:\s*(.+)/
      current_monkey.operation = $1
    when /^Test:\s*(.+)/
      current_monkey.test = $1
    when /^If true: throw to monkey (.+)/
      current_monkey.if_true_monkey = $1.to_i
    when /^If false: throw to monkey (.+)/
      current_monkey.if_false_monkey = $1.to_i
    else
      raise "unsupported line #{line}"
    end
  end

  monkeys << current_monkey

  monkeys
end

def part1
  monkeys = parse_monkeys
  monkeys_by_id = monkeys.map { |m| [m.id, m] }.to_h

  20.times do
    monkeys.each do |monkey|
      while item = monkey.items.shift
        worry_level = monkey.inspect_item(item)
        worry_level /= 3
        if monkey.test?(worry_level)
          monkeys.fetch(monkey.if_true_monkey).receive(worry_level)
        else
          monkeys.fetch(monkey.if_false_monkey).receive(worry_level)
        end
      end
    end
  end

  monkey_business = monkeys.map(&:num_inspections).max(2).inject(&:*)
  puts monkey_business
end

def part2
  monkeys = parse_monkeys
  monkeys_by_id = monkeys.map { |m| [m.id, m] }.to_h
  # I'm a genius
  d = monkeys.map(&:prime).inject(&:*)

  10_000.times do
    monkeys.each do |monkey|
      while item = monkey.items.shift
        worry_level = monkey.inspect_item(item)
        worry_level %= d
        if monkey.test?(worry_level)
          monkeys.fetch(monkey.if_true_monkey).receive(worry_level)
        else
          monkeys.fetch(monkey.if_false_monkey).receive(worry_level)
        end
      end
    end
  end

  monkey_business = monkeys.map(&:num_inspections).max(2).inject(&:*)
  puts monkey_business
end

part2

__END__
Monkey 0:
  Starting items: 54, 53
  Operation: new = old * 3
  Test: divisible by 2
    If true: throw to monkey 2
    If false: throw to monkey 6

Monkey 1:
  Starting items: 95, 88, 75, 81, 91, 67, 65, 84
  Operation: new = old * 11
  Test: divisible by 7
    If true: throw to monkey 3
    If false: throw to monkey 4

Monkey 2:
  Starting items: 76, 81, 50, 93, 96, 81, 83
  Operation: new = old + 6
  Test: divisible by 3
    If true: throw to monkey 5
    If false: throw to monkey 1

Monkey 3:
  Starting items: 83, 85, 85, 63
  Operation: new = old + 4
  Test: divisible by 11
    If true: throw to monkey 7
    If false: throw to monkey 4

Monkey 4:
  Starting items: 85, 52, 64
  Operation: new = old + 8
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 7

Monkey 5:
  Starting items: 57
  Operation: new = old + 2
  Test: divisible by 5
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 6:
  Starting items: 60, 95, 76, 66, 91
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 2
    If false: throw to monkey 5

Monkey 7:
  Starting items: 65, 84, 76, 72, 79, 65
  Operation: new = old + 5
  Test: divisible by 19
    If true: throw to monkey 6
    If false: throw to monkey 0
