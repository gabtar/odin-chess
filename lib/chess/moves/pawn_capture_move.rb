# frozen_string_literal: true

require_relative './move'

# A capture move only for pawns
class PawnCaptureMove < Move
  def validate
    pawn_color = @from_piece.color

    if pawn_color == 'white'
      raise IllegalMoveError, 'Illegal piece move' unless @to_piece.color != pawn_color
    elsif pawn_color == 'black'
      raise IllegalMoveError, 'Illegal piece move' unless  @to_piece.color != pawn_color
    end
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @from)
    @board.add_piece(@from_piece, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    "#{@from}x#{@to}"
  end
end
