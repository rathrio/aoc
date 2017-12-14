#!/usr/bin/env ruby

require 'strscan'

class Group
  def groups
    @groups ||= []
  end

  def score(init = 1)
    groups.sum { |g| g.score(init + 1) } + init
  end
end

$stack = []
$root_group = nil

input = ARGF.read.chomp
s = StringScanner.new(input)

LCURLY  = /{/
RCURLY  = /}/
GARBAGE = /<((?!>)(!!|!>|[^>])*)?>/
COMMA   = /,/

def current_group
  $stack.last
end

def push_group
  group = Group.new

  if current_group.nil?
    $root_group = group
  else
    current_group.groups << group
  end

  $stack.push(group)
  true
end

def pop_group
  $stack.pop
  true
end

def parse_garbage(s)
  s.scan(GARBAGE)
end

def parse_content(s)
  parse_group(s) || parse_garbage(s)
end

def parse_comma(s)
  s.scan(COMMA)
end

def parse_comma_content(s)
  parse_comma(s) && parse_content(s) && (parse_comma_content(s) || epsilon(s))
end

def parse_list(s)
  parse_content(s) && (parse_comma_content(s) || epsilon(s))
end

def epsilon(s)
  true
end

def parse_group(s)
  s.scan(LCURLY) &&
    push_group &&
    (parse_list(s) || epsilon(s)) &&
    s.scan(RCURLY) &&
    pop_group
end

until s.eos?
  parse_group(s)
end

puts $root_group.score
