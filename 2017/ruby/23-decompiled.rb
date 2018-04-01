# Init registers
a = 1
b = 0
c = 0
d = 0
f = 0
e = 0
f = 0
g = 0
h = 0
# set b 93
b = 93
# set c b
c = b
# jnz a 2
if a != 0
  # mul b 100
  b *= 100
  # sub b -100000
  b += 100_000
  # set c b
  c = b
  # sub c -17000
  c += 17_000
  # set f 1
  f = 1
  # set d 2
  d = 2
  # set e 2
  e = 2
  # set g d
  g = d
  # mul g e
  g *= e
  # sub g b
  g -= b
  # jnz g 2
  if g != 0
    # sub e -1
    e += 1
    # set g e
    g = e
    # sub g b
    g -= b
    # jnz g -8
  end


end
# jnz 1 5
