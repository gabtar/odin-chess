# frozen_string_literal: true

# A chess player for the game
#
# @attr colour [String] the colour army of the player
class Player
  attr_reader :colour
  attr_accessor :captured_pieces

  def initialize(colour)
    @colour = colour
    @captured_pieces = []
  end
end
