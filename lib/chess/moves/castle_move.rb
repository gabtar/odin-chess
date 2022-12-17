# frozen_string_literal: true

require_relative './move'

# A castle move in chess
class CastleMove < Move
  def validate
    # TODO, check that for the king is the first move, maybe a flag on the king?
    raise IllegalMoveError, 'Illegal move' if @board.in_check?(@board, @from_piece.color)
    raise IllegalMoveError, 'Invalid castle' if @board.path_attacked?(@from, @to, @from_piece.color)
    raise IllegalMoveError, 'Path blocked' if @board.blocked_path?(@from, @to)
  end

  # Performs the move in the board
  def execute
    # Move the king
    @board.add_piece(nil, @from)
    @board.add_piece(@from_piece, @to)

    # Move the rook
    rook_square = short? ? "h#{@from[1]}" : "a#{@from[1]}"
    rook = @board.get_piece_at(rook_square)
    rook_destination = short? ? "f#{@from[1]}" : "d#{@from[1]}"
    @board.add_piece(nil, rook_square)
    @board.add_piece(rook, rook_destination)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in algebraic notation
  def long_algebraic_notation
    return '0-0' if short?

    '0-0-0'
  end

  private

  # Determines if it's a short castle
  # @return [Boolean] true if its a short castle for any army
  def short?
    return true if @to[0] == 'g'

    false
  end
end
