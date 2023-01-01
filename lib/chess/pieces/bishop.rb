# frozen_string_literal: true

require_relative './piece'
require_relative './mixins/basic_directional_move'

# Represents a Bishop in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Bishop < Piece
  include BasicDirectionalMove

  def initialize(color)
    symbol = color == 'white' ? '♝' : '♗'
    fen_representation = color == 'white' ? 'B' : 'b'
    super(color, symbol, fen_representation)
    # default move = diagonals
    # directions!
    @possible_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end
