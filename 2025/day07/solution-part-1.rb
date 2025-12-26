#!/usr/bin/env ruby
# frozen_string_literal: true

def find_beam_positions(row)
  row.map.with_index { |cell, idx| (cell == "|" && idx) || nil }.compact
end

def split_beams_next_step(previous_step, next_step)
  previous_step.map.with_index do |cell_above, idx|
    left_cell = next_step[idx - 1]
    right_cell = next_step[idx + 1]
    this_cell = next_step[idx]

    if (right_cell == "^" && previous_step[idx + 1] == "|") ||
       (left_cell == "^" && previous_step[idx - 1] == "|")
      "|"
    elsif cell_above == "|" && this_cell != "^"
      previous_step[idx]
    else
      this_cell
    end
  end
end

def split_beams(previous_step, steps)
  return 0 if steps.empty?

  beam_positions = find_beam_positions(previous_step)

  next_step, *rest = steps

  splitters_used = beam_positions.map { |i| next_step[i] == "^" ? 1 : 0 }.sum
  next_step = split_beams_next_step(previous_step, next_step)

  puts "#{next_step.join} #{splitters_used}"
  splitters_used + split_beams(next_step, rest)
end

def solve_beam_paths(rows)
  first, *rest = rows
  first = first.map { |cell| cell == "S" ? "|" : cell }
  puts first.join

  split_beams(first, rest)
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp).map(&:chars)

  result = solve_beam_paths(rows)
  puts result
end
