#!/usr/bin/env ruby
# frozen_string_literal: true

def count_timelines(beam_position, rows)
  return 1 if rows.empty?

  this_level, *rest = rows
  count = 0

  if this_level[beam_position] == "^"
    if beam_position > 0
      # Beam splits to the left
      count = count_timelines(beam_position - 1, rest)
    end
    if beam_position < this_level.size - 1
      # Beam splits to the right
      count += count_timelines(beam_position + 1, rest)
    end
    count
  else
    count_timelines(beam_position, rest)
  end
end

File.open("input2", "r") do |file|
  rows = file.readlines.map(&:chomp).map(&:chars)

  first, *rest = rows
  first = first.map { |cell| cell == "S" ? "|" : cell }
  beam_position = first.find_index("|")

  result = count_timelines(beam_position, rest)
  puts result
end
