# frozen_string_literal: true

require_relative './move'

# A move when a Pawn is moved 2 squares ahead
class FirstPawnMove < Move
  def initialize(from, to, board)
    super(from, to, board)
    @pawn_color = @from_piece.color
  end

  def validate
    # TODO, check blocked path...
    raise IllegalMoveError, 'Illegal piece move' if @pawn_color == 'white' && @from[1] != '2'
    raise IllegalMoveError, 'Illegal piece move' if @pawn_color == 'black' && @from[1] != '7'

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
