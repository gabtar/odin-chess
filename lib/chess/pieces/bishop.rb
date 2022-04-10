# frozen_string_literal: true

require_relative './piece'

# Represents a Bishop in a chess game
#
# @attr [String] color piece color(eg. black or white)
class Bishop < Piece
  def initialize(color)
    super(color)
    # default move = diagonals
    # directions!
    @posibles_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    @max_depth_squares = 8
    generate_posible_moves
  end

  def can_move?(board, from, to)
    distance = board.calculate_distance_vector(from, to)
    @posibles_moves.include?(distance)
  end

  def can_capture?(board, from, to)
    can_move?(board, from, to)
  end

  # Piece representation
  def to_s
    color == 'white' ? '♗' : '♝'
  end

  private

  # Generates all posibles moves for the bishop in the four directions
  # TODO, Refactor!!!
  def generate_posible_moves
    @posibles_moves = []

    @posibles_directions.each do |direction|
      moves = [direction]
      7.times do
        moves << [moves.last[0] + moves.first[0], moves.last[1] + moves.first[1]]
      end
      @posibles_moves.concat(moves)
    end
    @posibles_moves
  end
end
