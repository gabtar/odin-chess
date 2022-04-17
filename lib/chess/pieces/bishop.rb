# frozen_string_literal: true

require_relative './piece'
require_relative './mixins/basic_directional_move'

# Represents a Bishop in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Bishop < Piece
  include BasicDirectionalMove

  def initialize(color)
    super(color)
    # default move = diagonals
    # directions!
    @possible_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end

  # Checks if the bishop defends the +to+ square at +from+ position in the
  # current board status
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def defends_square?(board, from, to)
    move_direction = board.calculate_direction_vector(from, to)
    blocked = board.blocked_path?(from, to)

    @possible_directions.include?(move_direction) && !blocked
  end

  # Bishop representation
  def to_s
    color == 'white' ? '♗' : '♝'
  end
end
