#!/usr/bin/env ruby
# frozen_string_literal: true

def invalid_id?(id)
  return false if id.length.odd? # cannot be a mirror if odd lenght.

  left, right = [
    id.slice(0, (id.length/2)),
    id.slice((id.length/2), id.length)
  ]

  left == right
end

def find_invalid_ids(range)
  from, to = range.split("-").map(&:to_i)

  (from..to).select { |id| invalid_id?(id.to_s) }
end

File.open("input", "r") do |file|
  ranges = file.readline.split(",")
  puts "Ranges: #{ranges.size}"

  result = ranges.map { |range| find_invalid_ids(range) }.flatten.sum(0)
  puts "Result: #{result}"
end
