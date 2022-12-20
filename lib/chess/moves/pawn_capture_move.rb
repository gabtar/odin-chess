# frozen_string_literal: true

require_relative './move'

# A capture move only for pawns
class PawnCaptureMove < Move
  def validate
    white_captures_distances = [[1, 1], [1, -1]]
    black_captures_distances = [[-1, 1], [-1, -1]]
    distance = @board.calculate_distance_vector(@from, @to)
    pawn_color = @from_piece.color

    raise IllegalMoveError, 'Illegal move' if @to_piece.nil? || @to_piece.color == pawn_color

    case pawn_color
    when 'white'
      unless @to_piece.color != pawn_color && white_captures_distances.include?(distance)
        raise IllegalMoveError,
              'Illegal piece move'
      end
    when 'black'
      unless @to_piece.color != pawn_color && black_captures_distances.include?(distance)
        raise IllegalMoveError,
              'Illegal piece move'
      end
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
