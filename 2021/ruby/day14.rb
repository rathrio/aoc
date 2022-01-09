lines = DATA.readlines.map(&:chomp)
TEMPLATE = lines.shift
lines.shift

INSERTIONS = lines.map { |line| line.split(' -> ') }.to_h

def part1
  template = TEMPLATE.clone

  10.times do |i|
    polymer = +''

    pairs = template.chars.each_cons(2).to_a
    pairs.each do |pair|
      polymer << pair[0]

      if (insertion = INSERTIONS[pair.join])
        polymer << insertion
      end
    end

    polymer << pairs.last[1]
    template = polymer
  end

  chars = template.chars.uniq
  counts = chars.map { |char| [char, template.count(char)] }.to_h

  puts counts.values.max - counts.values.min
end

def part2
  template = TEMPLATE.clone
  pairs = template.chars.each_cons(2).to_a
  pair_counts = pairs.map { |pair| [pair.join, pairs.count(pair)] }.to_h
  char_counts = template.chars.map { |c| [c, template.count(c)] }.to_h

  40.times do |i|
    updates = Hash.new(0)

    pair_counts.each do |pair, count|
      if (insertion = INSERTIONS[pair])
        char_counts[insertion] ||= 0
        char_counts[insertion] += (1 * count)

        updates[pair] -= (1 * count)

        new_pair1 = pair[0] + insertion
        new_pair2 = insertion + pair[1]
        updates[new_pair1] += (1 * count)
        updates[new_pair2] += (1 * count)
      end
    end

    updates.each do |pair, delta|
      pair_counts[pair] ||= 0
      pair_counts[pair] += delta

      if pair_counts[pair].zero?
        pair_counts.delete(pair)
      end
    end
  end

  puts char_counts.values.max - char_counts.values.min
end

part2

__END__
BNBBNCFHHKOSCHBKKSHN

CH -> S
KK -> V
FS -> V
CN -> P
VC -> N
CB -> V
VK -> H
CF -> N
PO -> O
KC -> S
HC -> P
PP -> B
KO -> B
BK -> P
BH -> N
CC -> N
PC -> O
FK -> N
KF -> F
FH -> S
SS -> V
ON -> K
OV -> K
NK -> H
BO -> C
VP -> O
CS -> V
KS -> K
SK -> B
OP -> S
PK -> S
HF -> P
SV -> P
SB -> C
BC -> C
FP -> H
FC -> P
PB -> N
NV -> F
VO -> F
VH -> P
BB -> N
SF -> F
NB -> K
KB -> S
VV -> S
NP -> N
SO -> O
PN -> B
BP -> H
BV -> V
OB -> C
HV -> N
PF -> B
SP -> N
HN -> N
CV -> H
BN -> V
PS -> V
CO -> S
BS -> N
VB -> H
PV -> P
NN -> P
HS -> C
OS -> P
FB -> S
HO -> C
KH -> H
HB -> K
VF -> S
CK -> K
FF -> H
FN -> P
OK -> F
SC -> B
HH -> N
OH -> O
VS -> N
FO -> N
OC -> H
NF -> F
PH -> S
HK -> K
NH -> H
FV -> S
OF -> V
NC -> O
HP -> O
KP -> B
BF -> N
NO -> S
CP -> C
NS -> N
VN -> K
KV -> N
OO -> V
SN -> O
KN -> C
SH -> F
