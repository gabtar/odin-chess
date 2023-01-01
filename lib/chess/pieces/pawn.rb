# frozen_string_literal: true

require_relative './piece'

# Represents a Pawn in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Pawn < Piece
  def initialize(color)
    symbol = color == 'white' ? '♟' : '♙'
    fen_representation = color == 'white' ? 'P' : 'p'
    super(color, symbol, fen_representation)
    # default move = +1 rank, same file
    # +2 ranks on first move
    # [-1, 1] and [1, 1] only when capturing
    white_moves = [[1, 0], [2, 0]]
    black_moves = [[-1, 0], [-2, 0]]
    @allowed_distances = color == 'white' ? white_moves : black_moves
  end

  # Indicates if the a Pawn can move +from+ specified square +to+ destination
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    return true if @allowed_distances.include?(board.calculate_distance_vector(from, to))

    false
  end
end
