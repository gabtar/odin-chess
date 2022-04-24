# frozen_string_literal: true

# Basic class for chess piecess
#
# @attr [String] color piece color (eg. black or white)
class Piece
  attr_reader :color

  def initialize(color, symbol)
    @color = color
    @symbol = symbol
  end

  # Indicates if the +other_piece+ is a same color piece or not.
  # @param other_piece [Piece] the piece we want to know if it's of the opponent's army
  def same_color?(other_piece)
    return false if other_piece.nil?

    color == other_piece.color
  end

  # Piece symbol representation
  def to_s
    @symbol
  end
end
