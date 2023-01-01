# frozen_string_literal: true

require_relative './piece'
require_relative './mixins/basic_directional_move'

# Represents a Rook in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Rook < Piece
  attr_accessor :moved

  include BasicDirectionalMove

  def initialize(color)
    symbol = color == 'white' ? '♜' : '♖'
    fen_representation = color == 'white' ? 'R' : 'r'
    super(color, symbol, fen_representation)
    # default move = horizontal + vertical
    @moved = false
    @possible_directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end
