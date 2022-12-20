# frozen_string_literal: true

require_relative './move'

# A normal/piece movement in chess
class CaptureMove < Move
  def validate
    raise IllegalMoveError, 'Illegal piece move' unless @from_piece.can_move_to?(@board, @from,
                                                                                 @to) || @to_piece.color == @from_piece.color
    raise IllegalMoveError, 'Path blocked' if !@from_piece.is_a?(Knight) && @board.blocked_path?(@from, @to)
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @from)
    @board.add_piece(@from_piece, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    "#{@from_piece}#{@from}x#{@to}"
  end
end
