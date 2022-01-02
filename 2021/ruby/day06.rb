def part1
  fish = DATA.read.chomp.split(',').map(&:to_i)

  (1..80).each do |day|
    new_fish = 0

    fish.each_with_index do |f, i|
      if f.zero?
        new_fish += 1
        fish[i] = 6
        next
      end

      fish[i] -= 1
    end

    fish += ([8] * new_fish)
  end

  puts fish.size
end

# part1's approach is naive and too slow. I initially wanted to model
# exponential growth, but that turned out to be too imprecise for this task
# given the various start counters (could have probably accounted for them as
# well).
#
# Turns out I only need a more compact representation of the fish, so using a
# Hash that maps the known timer values to the number of fish that currently
# have it is way more compact and we are now linear (with regard to days)!
def part2
  fish = DATA.read.chomp.split(',').map(&:to_i)
  swarms = fish
    .group_by { |f| f }
    .map { |k, v| [k, v.size] }.to_h

  (1..256).each do |day|
    new_swarms = Hash.new(0)

    swarms.each do |timer, num_fish|
      if timer.zero?
        new_swarms[6] += num_fish
        new_swarms[8] += num_fish
      else
        new_swarms[timer - 1] += num_fish
      end
    end

    swarms = new_swarms
  end

  puts swarms.values.sum
end

puts part2

__END__
1,1,1,1,3,1,4,1,4,1,1,2,5,2,5,1,1,1,4,3,1,4,1,1,1,1,1,1,1,2,1,2,4,1,1,1,1,1,1,1,3,1,1,5,1,1,2,1,5,1,1,1,1,1,1,1,1,4,3,1,1,1,2,1,1,5,2,1,1,1,1,4,5,1,1,2,4,1,1,1,5,1,1,1,1,5,1,3,1,1,4,2,1,5,1,2,1,1,1,1,1,3,3,1,5,1,1,1,1,3,1,1,1,4,1,1,1,4,1,4,3,1,1,1,4,1,2,1,1,1,2,1,1,1,1,5,1,1,3,5,1,1,5,2,1,1,1,1,1,4,4,1,1,2,1,1,1,4,1,1,1,1,5,3,1,1,1,5,1,1,1,4,1,4,1,1,1,5,1,1,3,2,2,1,1,1,4,1,3,1,1,1,2,1,3,1,1,1,1,4,1,1,1,1,2,1,4,1,1,1,1,1,4,1,1,2,4,2,1,2,3,1,3,1,1,2,1,1,1,3,1,1,3,1,1,4,1,3,1,1,2,1,1,1,4,1,1,3,1,1,5,1,1,3,1,1,1,1,5,1,1,1,1,1,2,3,4,1,1,1,1,1,2,1,1,1,1,1,1,1,3,2,2,1,3,5,1,1,4,4,1,3,4,1,2,4,1,1,3,1
