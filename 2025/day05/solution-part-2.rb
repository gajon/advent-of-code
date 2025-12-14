#!/usr/bin/env ruby
# frozen_string_literal: true

def extract_ranges(rows)
  divider_index = rows.find_index("")
  rows[0, divider_index].map { |range| range.split("-").map(&:to_i) }
end

def solve(new_ranges, ranges)
  next_range, *rest = ranges
  return new_ranges unless next_range

  previous_range = new_ranges.last

  if next_range[0].between?(previous_range[0], previous_range[1])
    previous_range[1] = [previous_range[1], next_range[1]].max
    solve(new_ranges, rest)
  else
    solve(new_ranges + [next_range], rest)
  end
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp)

  ranges = extract_ranges(rows).sort
  first, *rest = ranges

  new_ranges = solve([first], rest)
  puts "New ranges: #{new_ranges.size}"

  result = new_ranges.reduce(0) do |count, range|
    count + (range[1] - range[0]) + 1
  end

  puts "Result: #{result}"
end

# The following was my first naive attempt. But, I had to rethink it when it
# ballooned past 70 GB of RAM when running.
#
# File.open("input", "r") do |file|
#   rows = file.readlines.map(&:chomp)
#
#   divider_index = rows.find_index("")
#   ranges = extract_ranges(rows[0, divider_index])
#
#   ids_set = Set.new
#
#   ranges
#     .map { |rstart, rend| (rstart..rend).map(&:to_i) }
#     .map { |ids| ids_set.merge(ids) }
#
#   puts "Result: #{ids_set.size}"
# end
