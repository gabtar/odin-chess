# frozen_string_literal: true

require_relative './piece'
# require 'pry-byebug'

# Represents a King in a chess game
#
# @attr [String] color piece color(eg. black or white)
class King < Piece
  attr_accessor :moved

  def initialize(color)
    symbol = color == 'white' ? '♚' : '♔'
    fen_representation = color == 'white' ? 'K' : 'k'
    super(color, symbol, fen_representation)
    # default move = horizontal + vertical + diagonals
    # but only 1 square at a time
    @possible_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    @moved = false
  end

  # Indicates if the King can move +from+ specified square +to+ destination
  # with particular rules for king movement in the current +board+ context
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    move_direction = board.calculate_distance_vector(from, to)
    blocked_by_same_color = same_color?(board.get_piece_at(to))

    @possible_directions.include?(move_direction) && !blocked_by_same_color
  end
end
