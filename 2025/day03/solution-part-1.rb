#!/usr/bin/env ruby
# frozen_string_literal: true

def find_joltage(bank)
  digits = bank.split(//).map(&:to_i)

  first_biggest_digit = digits[0...-1].max # this slice excludes last digit
  first_position = digits[0...-1].index(first_biggest_digit)

  next_biggest_digit = digits[first_position+1..-1].max # second slice up to last digit

  (first_biggest_digit.to_s + next_biggest_digit.to_s).to_i
end

File.open("input", "r") do |file|
  banks = file.readlines.map(&:chomp)
  puts "Banks: #{banks.size}"

  result = banks.map { |bank| find_joltage(bank) }.sum
  puts "Result: #{result}"
end
