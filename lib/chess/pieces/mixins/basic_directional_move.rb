# frozen_string_literal: true

# Mixin for basic move in horizontal, vertical, diagonal axis for Pieces
module BasicDirectionalMove
  # Indicates if the Piece can move +from+ specified square +to+ destination
  # depending on the directions Array defined in each piece implementation
  # in the current +board+ context
  # @param board [Board] a chess board object
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def can_move_to?(board, from, to)
    move_direction = board.calculate_direction_vector(from, to)
    @possible_directions.include?(move_direction)
  rescue IllegalMoveError
    false
  end
end
