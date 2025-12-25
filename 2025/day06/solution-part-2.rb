#!/usr/bin/env ruby
# frozen_string_literal: true

def determine_column_sizes(operands)
  columns = []

  operands.chars.inject([]) do |memo, value|
    if value == "\n"
      # All columns have an extra " " as a separator between columns.
      # Last column should have it too.
      columns << (memo << " ")
      []
    elsif value != " " && !memo.empty?
      columns << memo
      [value]
    else
      memo << value
      memo
    end
  end

  columns.map(&:size)
end

def read_numbers_from_column(lines, base_offset, width)
  width.times.map do |idx|
    offset = base_offset + idx
    lines.map { |line| line[offset] }.join.to_i
  end
end

def read_numbers_from_columns(lines, column_sizes)
  offset = 0
  column_sizes.map do |column_size|
    numbers = read_numbers_from_column(lines, offset, column_size - 1)
    offset += column_size
    numbers
  end
end

File.open("input", "r") do |file|
  *lines, operands = file.readlines

  column_sizes = determine_column_sizes(operands)
  numbers = read_numbers_from_columns(lines, column_sizes)

  results = operands.split.map.with_index do |operand, index|
    numbers[index].reduce(operand.to_sym)
  end

  puts "Result: #{results.sum}"
end
