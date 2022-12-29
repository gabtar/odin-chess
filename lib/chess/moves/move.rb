# frozen_string_literal: true

# A move of chess
#
# @attr from [String] the starting position sqaure
# @attr to [String] the ending position square
# @attr board [Board] the board with the position before the move
class Move
  attr_accessor :from, :to, :from_piece, :notation, :board, :fen_string

  def initialize(from, to, board)
    @from = from
    @to = to
    @board = board
    @from_piece = @board.get_piece_at(@from)
    @to_piece = @board.get_piece_at(@to)
    @fen_string = @board.to_fen
    @notation = nil
  end
end
