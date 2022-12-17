# frozen_string_literal: true

# A chess player for the game
#
# @attr colour [String] the colour army of the player
class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end
