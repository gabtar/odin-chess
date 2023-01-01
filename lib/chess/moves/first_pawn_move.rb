# frozen_string_literal: true

require_relative './move'

# A move when a Pawn is moved 2 squares ahead
class FirstPawnMove < Move
  attr_reader :en_passant_target_square

  def initialize(from, to, board)
    super(from, to, board)
    @pawn_color = @from_piece.color
    # For now for fen string notation only
    @en_passant_target_square = "#{@from[0]}#{(@to[1].to_i + @from[1].to_i) / 2}"
  end

  def validate
    raise IllegalMoveError, 'Blocked path' if @board.blocked_path?(@from, @to) || !@to_piece.nil?
    raise IllegalMoveError, 'Illegal piece move' if @pawn_color == 'white' && @from[1] != '2'
    raise IllegalMoveError, 'Illegal piece move' if @pawn_color == 'black' && @from[1] != '7'
    raise IllegalMoveError, 'Illegal piece move' unless @from_piece.can_move_to?(@board, @from, @to)
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @from)
    @board.add_piece(@from_piece, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    "#{@from}#{@to}"
  end
end
