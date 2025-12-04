#!/usr/bin/env ruby
# frozen_string_literal: true

def find_invalid_ids(range)
  from, to = range.split("-").map(&:to_i)

  (from..to).select { |id| invalid_id?(id.to_s) }
end

def invalid_id?(id)
  return false unless id.length > 1

  # start by splitting the id at the middle, and make smaller groups
  # until we find that they are all the same, or grouping_size is zero.
  grouping_size = id.length / 2 

  # this is slow, it takes around 7 seconds to finish :))) but it is easy
  while grouping_size > 0 do
    return true if make_groups_of(grouping_size, id).uniq.size == 1
    grouping_size -= 1
  end

  false
end

# for example, make_groups_of(2, "12345") => ["12", "34", "5"]
def make_groups_of(n, string)
  return [] if n.zero? || string.nil? || string.empty?

  group, rest = [string.slice(0, n), string.slice(n, string.length)]
  [group] + make_groups_of(n, rest)
end

File.open("input", "r") do |file|
  ranges = file.readline.split(",")
  puts "Ranges: #{ranges.size}"

  result = ranges.map { |range| find_invalid_ids(range) }.flatten.sum(0)
  puts "\nResult: #{result}"
end
