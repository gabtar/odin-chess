# frozen_string_literal: true

require_relative './piece'
require_relative './mixins/basic_directional_move'

# Represents a Queen in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Queen < Piece
  include BasicDirectionalMove

  def initialize(color)
    symbol = color == 'white' ? '♛' : '♕'
    fen_representation = color == 'white' ? 'Q' : 'q'
    super(color, symbol, fen_representation)
    # default move = horizontal + vertical + diagonals
    @possible_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end
