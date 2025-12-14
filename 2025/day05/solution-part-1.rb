#!/usr/bin/env ruby
# frozen_string_literal: true

def extract_ranges(rows)
  rows.map { |range| range.split("-").map(&:to_i) }
end

def extract_ids(rows)
  rows.map(&:to_i)
end

def fresh?(id, ranges)
  ranges.any? { |rstart, rend| id.between?(rstart, rend) }
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp)

  divider_index = rows.find_index("")
  ranges = extract_ranges(rows[0, divider_index])
  ids = extract_ids(rows[(divider_index + 1)..])

  result = ids.select { |id| fresh?(id, ranges) }.size

  puts "Fresh ingredients: #{result}"
end
