# frozen_string_literal: true

require_relative './piece'

# Represents a Pawn in a chess game
#
# @attr [String] color piece color(eg. black or white)
# @attr [Boolean] jump indicates if the pice can jump other pieces in the board
class Pawn < Piece
  def initialize(color)
    super(color)
    # default move = +1 rank, same file
    # +2 ranks on first move
    # [-1, 1] and [1, 1] only when capturing
    @posible_moves = [[1, 0], [2, 0]]
    @posibles_captures = [[1, 1], [1, -1]]
  end

  # Indicates if the a Pawn can move +from+ specified square +to+ destination
  # square
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move?(board, from, to)
    from_rank, from_file = board.parse_coordinate(from)
    distance = board.calculate_distance_vector(from, to)

    # False if not from second rank
    return false if distance == [2, 0] && from_rank != 1

    return true if @posible_moves.include?(distance)

    false
  end

  def can_capture?(board, from, to)
    distance = board.calculate_distance_vector(from, to)

    return true if @posibles_captures.include?(distance)

    false
  end

  # Piece representation
  def to_s
    color == 'white' ? '♙' : '♟'
  end
end
