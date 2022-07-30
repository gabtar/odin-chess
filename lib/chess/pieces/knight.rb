# frozen_string_literal: true

require_relative './piece'

# Represents a Knight in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Knight < Piece
  def initialize(color)
    symbol = color == 'white' ? '♘' : '♞'
    super(color, symbol)
    # default move = jumps in L shape move
    @possible_directions = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
  end

  # Indicates if the a Knight can move +from+ specified square +to+ destination
  # in the current +board+ context
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    move_distance = board.calculate_distance_vector(from, to)

    if same_color?(board.get_piece_at(to))
      false
    else
      @possible_directions.include?(move_distance)
    end
  end
end
