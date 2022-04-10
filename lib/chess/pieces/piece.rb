# frozen_string_literal: true

# Basic class for chess piecess
#
# @attr [String] color piece color (eg. black or white)
# @attr [Boolean] jump indicates if the pice can jump other pieces in the board
class Piece
  attr_reader :color

  def initialize(color, jump = false)
    @color = color
    @jump = jump
  end

  # Indicates if the piece can move +from+ specified square +to+ destination
  # square
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move?(board, from, to)
    false
  end
end
