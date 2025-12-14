#!/usr/bin/env ruby
# frozen_string_literal: true

def perform_op(row)
  *numbers, operand = row
  numbers.map(&:to_i).reduce(operand.to_sym)
end

File.open("input", "r") do |file|
  rows = file.readlines.map(&:chomp).map(&:split)

  result = rows.transpose.map { |row| perform_op(row) }.sum
  puts "Result: #{result}"
end
