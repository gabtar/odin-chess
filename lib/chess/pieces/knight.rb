# frozen_string_literal: true

require_relative './piece'

# Represents a Knight in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Knight < Piece
  def initialize(color)
    symbol = color == 'white' ? '♞' : '♘'
    fen_representation = color == 'white' ? 'N' : 'n'
    super(color, symbol, fen_representation)
    # default move = jumps in L shape move
    @possible_directions = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
  end

  # Indicates if the a Knight can jump +from+ specified square +to+ destination
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    @possible_directions.include?(board.calculate_distance_vector(from, to))
  end
end
