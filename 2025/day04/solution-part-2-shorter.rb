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
    (0...max_y).map do |y|
      (0...max_x).map do |x|
        if accessible?(x:, y:)
          @rows[y][x] = "x"
          1
        else
          0
        end
      end
    end.flatten.sum
  end

  private

  def accessible?(x:, y:)
    cell = cell_content(x:, y:)
    cell == "@" && neighboring_rolls(x:, y:) < 4
  end

  def neighboring_rolls(x:, y:)
    neighbors = cell_neighbors(x:, y:)
    neighbors.select { |n| ["@", "x"].include?(n) }.size
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
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp)
  puts "Rows: #{rows.size}"

  grid = Grid.new(rows.map(&:chars))
  total = 0

  while (accessible_rolls = grid.accessible_rolls).positive?
    total += accessible_rolls
    new_rows = grid.rows.map { |row| row.map { |cell| cell == "x" ? "." : cell } }
    grid = Grid.new(new_rows)
  end

  puts "\nResult: #{total}"
end
