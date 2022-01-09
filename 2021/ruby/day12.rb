require 'set'

class String
  def small?
    return false if start? || end?

    downcase == self
  end

  def big?
    return false if start? || end?

    upcase == self
  end

  def start?
    self == 'start'
  end

  def end?
    self == 'end'
  end
end

EDGES = Hash.new

DATA.readlines.map(&:chomp).each do |line|
  l, r = line.split('-')
  (EDGES[l] ||= Set.new) << r
  (EDGES[r] ||= Set.new) << l
end

def find_end(cave, path, context)
  EDGES[cave].each do |neighbor|
    next if neighbor.start?

    # part1
    # next if neighbor.small? && path.any?(&:small?) && path.include?(neighbor) 

    # part2
    if neighbor.small? && path.include?(neighbor)
      counts = path.select(&:small?).map { |cave| [cave, path.count(cave)] }.to_h
      if counts.any? { |cave, count| count == 2 }
        next
      end
    end

    npath = path.clone

    if neighbor.end?
      npath << neighbor
      context[:num_paths] += 1
      next
    end

    npath << neighbor
    find_end(neighbor, npath, context)
  end
end

start = EDGES.fetch('start')
path = ['start']
context = { num_paths: 0 }
find_end('start', path, context)

puts context.fetch(:num_paths)

__END__
ax-end
xq-GF
end-xq
im-wg
ax-ie
start-ws
ie-ws
CV-start
ng-wg
ng-ie
GF-ng
ng-av
CV-end
ie-GF
CV-ie
im-xq
start-GF
GF-ws
wg-LY
CV-ws
im-CV
CV-wg
