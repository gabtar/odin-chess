# frozen_string_literal: true

require_relative './move'

# A promotion move
#
# @attr from [String] the starting position sqaure
# @attr to [String] the ending position square
# @attr board [Board] the board with the position before the move
# @attr board [Piece] the piece that the pawn will be promoted to
class PromotionMove < Move
  def initialize(from, to, board, promoted_to)
    super(from, to, board)
    @promoted_to = promoted_to
  end

  def validate
    raise IllegalMoveError, 'Illegal piece move' unless @from_piece.can_move_to?(@board, @from, @to)
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @from)
    @board.add_piece(@promoted_to, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    # TODO, if @board.in_check? add the + symbol
    # same for checkmate
    "#{@from_piece}#{@from}#{@to}#{@promoted_to}"
  end
end
