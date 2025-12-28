#!/usr/bin/env ruby
# frozen_string_literal: true

# This recursive solution is very slow.
def count_timelines_slow!(beam_position, rows)
  return 1 if rows.empty?

  this_level, *rest = rows
  count = 0

  if this_level[beam_position] == "^"
    if beam_position > 0
      # Beam splits to the left
      count = count_timelines_slow!(beam_position - 1, rest)
    end
    if beam_position < this_level.size - 1
      # Beam splits to the right
      count += count_timelines_slow!(beam_position + 1, rest)
    end
    count
  else
    count_timelines_slow!(beam_position, rest)
  end
end

# The above solution is very slow. This next one is traverses the levels only
# once, from top to bottom. But it builds a list of all possible timelines, and
# it grows excessively large. I'm discarding this solution too.
def split_timelines_grows_excessively!(timelines, next_steps)
  return timelines if next_steps.empty?

  this_step, *rest = next_steps
  new_timelines = []

  timelines.each do |timeline|
    # Each timeline contains only one beam. It can be split into two by
    # hitting a splitter in this step
    beam_pos = timeline.find_index("|")
    if this_step[beam_pos] == "^"
      timeline_one, timeline_two = split(this_step, beam_pos)
      new_timelines << timeline_one << timeline_two
    else
      new_timelines << timeline
    end
  end

  split_timelines_grows_excessively!(new_timelines, rest)
end

def split(step, beam_pos)
  # the beam_pos is the same position as the splitter that was hit
  timeline_one = step.dup
  timeline_two = step.dup
  timeline_one[beam_pos - 1] = "|"
  timeline_two[beam_pos + 1] = "|"

  [timeline_one, timeline_two]
end

#####################################################################

# THIRD ATTEMPT! I go back to the first recursive solution but build a 'memo'
# of how many timelines are reachable from each beam position. As we revisit a
# beam position a second time, we'll have the precomputed count of timelines
# ready.
def count_timelines(row, beam_position, rows, memo)
  return memo[[row, beam_position]] if memo[[row, beam_position]]
  return 1 if rows.empty?

  this_level, *rest = rows
  count = 0

  if this_level[beam_position] == "^"
    if beam_position > 0
      # Beam splits to the left
      count = count_timelines(row + 1, beam_position - 1, rest, memo)
    end
    if beam_position < this_level.size - 1
      # Beam splits to the right
      count += count_timelines(row + 1, beam_position + 1, rest, memo)
    end
  else
    count = count_timelines(row + 1, beam_position, rest, memo)
  end
  memo[[row, beam_position]] = count
  count
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp).map(&:chars)

  first, *rest = rows
  first = first.map { |cell| cell == "S" ? "|" : cell }
  beam_position = first.find_index("|")

  result = count_timelines(0, beam_position, rest, {})
  puts "Total timelines: #{result}"
end
