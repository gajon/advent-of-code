#!/usr/bin/env ruby
# frozen_string_literal: true

def find_joltage(bank)
  digits = bank.split(//).map(&:to_i)

  best_batteries(digits, 12).map(&:to_s).join.to_i
end

def best_batteries(digits, left_to_pick)
  return [] if left_to_pick.zero?

  # we need the biggest digit, excluding the left_to_pick-1 last digits
  available_digits = digits[0..-left_to_pick]

  biggest = available_digits.max
  next_split = available_digits.index(biggest) + 1

  [biggest] + best_batteries(digits[next_split..], left_to_pick - 1)
end

File.open("input", "r") do |file|
  banks = file.readlines.map(&:chomp)
  puts "Banks: #{banks.size}"

  # banks.each do |bank|
  #   joltage = find_joltage(bank)
  #   puts "#{bank}, joltage: #{joltage}"
  # end

  result = banks.map { |bank| find_joltage(bank) }.sum
  puts "Result: #{result}"
end
