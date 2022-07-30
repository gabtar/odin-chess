# frozen_string_literal: true

require_relative './piece'
require_relative './mixins/basic_directional_move'

# Represents a Bishop in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Bishop < Piece
  include BasicDirectionalMove

  def initialize(color)
    symbol = color == 'white' ? '♗' : '♝'
    super(color, symbol)
    # default move = diagonals
    # directions!
    @possible_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end
