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
    white_captures_distances = [[1, 1], [1, -1]]
    black_captures_distances = [[-1, 1], [-1, -1]]
    distance = @board.calculate_distance_vector(@from, @to)
    pawn_color = @from_piece.color

    if pawn_color == 'white' && white_captures_distances.include?(distance) && !@to_piece.nil?
      raise IllegalMoveError, 'Illegal piece move' unless @to_piece.color != pawn_color

      return
    elsif pawn_color == 'black' && black_captures_distances.include?(distance) && !@to_piece.nil?
      raise IllegalMoveError, 'Illegal piece move' unless @to_piece.color != pawn_color

      return
    end

    raise IllegalMoveError, 'Illegal move' unless @from_piece.can_move_to?(@board, @from, @to) && @to_piece.nil?
  end

  # Performs the move in the board
  def execute
    @board.add_piece(nil, @from)
    @board.add_piece(@promoted_to, @to)
  end

  # Outputs move in long algebraic notation
  # @return [String] the move in long algebraic notation
  def long_algebraic_notation
    "#{@from}#{@to}=#{@promoted_to}"
  end
end
