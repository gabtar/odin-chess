# frozen_string_literal: true

require_relative './move'

# An en passant pawn move
class EnPassantMove < Move
  def validate
    raise IllegalMoveError, 'Illegal capture' unless @board.last_move.is_a?(FirstPawnMove)
    #
    # # TODO, Validate that first_pawn_move is to the side we are capturing
    raise IllegalMoveError, 'Illegal capture' if @board.last_move.to[0] != @to[0]
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @board.last_move.to)
    @board.add_piece(nil, @from)
    @board.add_piece(@from_piece, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    "#{@from_piece}#{@from}x#{@to}e.p."
  end
end
