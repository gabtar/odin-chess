# frozen_string_literal: true

require_relative './move'

# A normal/piece movement in chess
class NormalMove < Move
  def validate
    raise IllegalMoveError.new('Illegal piece move') unless @from_piece.can_move_to?(@board, @from, @to)
    # raise IllegalMoveError.new('Cannot put king in check') if will_put_my_king_in_check(@from, @to)
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
