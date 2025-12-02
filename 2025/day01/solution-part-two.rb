#!/usr/bin/env ruby
# frozen_string_literal: true

class Dial
  attr_reader :position, :crossings_over_zero

  def initialize
    @position = 50
    @crossings_over_zero = 0
  end

  def new_position(movement)
    _, direction, steps = movement.split(/(\D)(\d+)/)
    direction == "L" ? left(steps.to_i) : right(steps.to_i)
    # printf "%3s Position: %2s - Crossings: %s\n", movement.chomp, @position, @crossings_over_zero
  end

  def left(n)
    previous_position_was_zero = @position.zero?
    @position = @position - n

    adjust_left_positions_and_count_crossings(previous_position_was_zero)
  end

  def right(n)
    @position = @position + n
    adjust_right_positions_and_count_crossing
  end

  private

  # Moving left is tricky because if you were already at position 0 before
  # moving, you don't count that initial zero a crossing over.
  #
  # If, after movement, you land at zero, count it as crossing once.
  def adjust_left_positions_and_count_crossings(previous_position_was_zero)
    return @crossings_over_zero += 1 if @position.zero?
    return unless @position.negative?

    if @position.negative? && !previous_position_was_zero
      @crossings_over_zero += 1
    end

    # Adds extra crossings for movements larger than -100
    @crossings_over_zero += @position / -100

    @position = @position % 100
  end

  def adjust_right_positions_and_count_crossing
    @crossings_over_zero += @position.abs / 100
    @position = @position % 100
  end
end

def decipher(dial, movements)
  movements.map { |mov| dial.new_position(mov) }
  dial.crossings_over_zero
end

File.open("input", "r") do |file|
  movements = file.readlines
  puts "Movements in the file #{movements.size}"

  password = decipher(Dial.new, movements)

  puts "Password to open the door: #{password}"
end
