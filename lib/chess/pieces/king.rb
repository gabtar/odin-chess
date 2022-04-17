# frozen_string_literal: true

require_relative './piece'
# require 'pry-byebug'

# Represents a King in a chess game
#
# @attr [String] color piece color(eg. black or white)
class King < Piece
  def initialize(color)
    super(color)
    # default move = horizontal + vertical + diagonals
    # but only 1 square at a time
    @possible_directions = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [-1, 0], [0, 1] [0, -1]]
  end

  # Indicates if the King can move +from+ specified square +to+ destination
  # with particular rules for king movement in the current +board+ context
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    move_direction = board.calculate_distance_vector(from, to)
    defended = false
    blocked_by_same_color = same_color?(board.get_piece_at(to))

    # If opponent piece cannot capture if it's defended
    unless board.get_piece_at(to).nil? && !same_color?(board.get_piece_at(to))
      # Check not defended by opponent pieces
      defended = board.defended?(to, 'white')
    end

    return true if @possible_directions.include?(move_direction) && !board.blocked_path?(from, to) && !defended && !blocked_by_same_color

    false
  end

  # Checks if the King defends the +to+ square at +from+ position in the
  # current board status
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def defends_square?(board, from, to)
    opposite_color = color == 'white' ? 'black' : 'white'
    @possible_directions.include?(board.calculate_distance_vector(from, to)) && !board.defended?(to, opposite_color)
  end

  # King representation
  def to_s
    color == 'white' ? '♔' : '♚'
  end
end
