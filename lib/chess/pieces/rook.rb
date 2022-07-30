# frozen_string_literal: true

require_relative './piece'
require_relative './mixins/basic_directional_move'

# Represents a Rook in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Rook < Piece
  include BasicDirectionalMove

  def initialize(color)
    symbol = color == 'white' ? '♖' : '♜'
    super(color, symbol)
    # default move = horizontal + vertical
    @possible_directions = [[1, 0], [-1, 0], [0, 1] [0, -1]]
  end
end
