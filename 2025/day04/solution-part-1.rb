#!/usr/bin/env ruby
# frozen_string_literal: true

class Grid
  attr_reader :rows, :max_x, :max_y

  def initialize(rows)
    @rows = rows
    @max_x = rows[0].size
    @max_y = rows.size
  end

  def accessible_rolls
    accessible_rolls_count = 0

    (0...max_y).each do |y|
      (0...max_x).each do |x|
        cell = cell_content(x:, y:)
        accessible_rolls_count += 1 if cell == "@" and accessible?(x:, y:)

        # print_cell(cell, x:, y:) # for debugging
      end
    end

    accessible_rolls_count
  end

  private

  def accessible?(x:, y:)
    neighbors = cell_neighbors(x:, y:)
    neighbors.select { |n| n == "@" }.size < 4
  end

  def cell_neighbors(x:, y:)
    [
      adjacent_cell_to(x:, y:, pos: :north_west),
      adjacent_cell_to(x:, y:, pos: :north),
      adjacent_cell_to(x:, y:, pos: :north_east),
      adjacent_cell_to(x:, y:, pos: :east),
      adjacent_cell_to(x:, y:, pos: :south_east),
      adjacent_cell_to(x:, y:, pos: :south),
      adjacent_cell_to(x:, y:, pos: :sout_west),
      adjacent_cell_to(x:, y:, pos: :west)
    ]
  end

  # Example,
  # rows = [[1, 2, 3],
  #         [4, 5, 6],
  #         [7, 8, 9]]
  #
  # Cell 4 is at x: 0, y: 1
  # Cell 9 is at x: 2, y: 2
  def adjacent_cell_to(x:, y:, pos:)
    case pos
    when :north_west then cell_content(x: x - 1, y: y - 1)
    when :north      then cell_content(x: x,     y: y - 1)
    when :north_east then cell_content(x: x + 1, y: y - 1)
    when :east       then cell_content(x: x + 1, y: y)
    when :south_east then cell_content(x: x + 1, y: y + 1)
    when :south      then cell_content(x: x,     y: y + 1)
    when :sout_west  then cell_content(x: x - 1, y: y + 1)
    when :west       then cell_content(x: x - 1, y: y)
    end
  end

  def cell_content(x:, y:)
    return if x.negative? || y.negative? || x >= max_x || y >= max_y

    rows[y][x]
  end

  def print_cell(cell, x:, y:)
    print "\n" if x.zero?

    if cell == "@" && accessible?(x:, y:)
      print "x"
    else
      print cell
    end
  end
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp)
  puts "Rows: #{rows.size}"

  grid = Grid.new(rows.map { |row| row.split(//) })
  puts "\nResult: #{grid.accessible_rolls}"
end
