# frozen_string_literal: true

require_relative './piece'

# Represents a Pawn in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Pawn < Piece
  def initialize(color)
    symbol = color == 'white' ? '♙' : '♟'
    super(color, symbol)
    # default move = +1 rank, same file
    # +2 ranks on first move
    # [-1, 1] and [1, 1] only when capturing
    @posible_moves = [[1, 0], [2, 0]]
    @posibles_captures = [[1, 1], [1, -1]]
  end

  # Indicates if the a Pawn can move +from+ specified square +to+ destination
  # in the current +board+ context
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    target_piece = board.get_piece_at(to)
    from_rank, = board.parse_coordinate(from)

    # Cant move if there is a same color piece on
    return false if same_color?(target_piece)

    # Check if there is a piece of oposite color
    # TODO, check en passant
    if target_piece && target_piece.color != color
      return true if @posibles_captures.include?(board.calculate_distance_vector(from, to))
    else
      # Check displacement
      distance = board.calculate_distance_vector(from, to)
      # TODO, check also for black, refactor!
      return false if distance == [2, 0] && from_rank != 1
      return true if @posible_moves.include?(distance) && !board.blocked_path?(from, to)
    end
    false
  end

  # Checks if the pawn defends the +to+ square at +from+ position in the
  # current board status
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def defends_square?(board, from, to)
    @posibles_captures.include?(board.calculate_distance_vector(from, to))
  end
end
