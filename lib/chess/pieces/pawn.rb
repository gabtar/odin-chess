# frozen_string_literal: true

require_relative './piece'

# Basic class for chess piecess
#
# @author Full Name
# @attr [Types] attribute_name a full description of the attribute
# @attr_reader [Types] name description of a readonly attribute
# @attr_writer [Types] name description of writeonly attribute
#
class Pawn < Piece
  def initialize(color)
    super(color)
    # default move = +1 rank, same file
    # +2 ranks on first move
    # [-1, 1] and [1, 1] only when capturing
    @posible_moves = [[1, 0], [2, 0], [1, 1], [-1, 1]]
    @posibles_captures = [[1, 1], [-1, 1]]
  end

  def can_move?(board, from, to)
    from_rank, from_file = board.parse_coordinate(from)
    to_rank, to_file = board.parse_coordinate(to)

    distance = board.calculate_distance_vector(from, to)

    # False if not from second rank
    return false if distance == [2, 0] && from_rank != 1

    return true if @posible_moves.include?(distance)

    false
  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end
end
