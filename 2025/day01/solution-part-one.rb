#!/usr/bin/env ruby
# frozen_string_literal: true

class Dial
  attr_reader :position

  def initialize
    @position = 50
  end

  def new_position(movement)
    _, direction, steps = movement.split(/(\D)(\d+)/)
    direction == "L" ? left(steps.to_i) : right(steps.to_i)
  end

  def left(n)
    @position = @position - n

    # while @position < 0 do; @position = @position + 100; end
    #
    # I had my initial solution use the while above, but then remembered modulo
    @position = @position % 100
  end

  def right(n)
    @position = @position + n
    @position = @position % 100
  end
end

def decipher(dial, movements)
  movements
    .map { |mov| dial.new_position(mov) }
    .select { |position| position.zero? }
    .count
end

File.open("input", "r") do |file|
  movements = file.readlines
  puts "Movements in the file #{movements.size}"

  password = decipher(Dial.new, movements)

  puts "Password to open the door: #{password}"
end
