# frozen_string_literal: true

require_relative './move'

# A move when a Pawn is moved 2 squares ahead
class FirstPawnMove < Move
  def validate
    # TODO, need to check if from rank 2 or 7 for black
    # And extract the logic from can_move_to
    raise IllegalMoveError, 'Illegal piece move' unless @from_piece.can_move_to?(@board, @from,
                                                                                 @to) || @to_piece.color == @from_piece.color
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @from)
    @board.add_piece(@from_piece, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    "#{@from_piece}#{@from}#{@to}"
  end
end
