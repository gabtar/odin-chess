# frozen_string_literal: true

require_relative './normal_move'
require_relative './castle_move'
require_relative './capture_move'
require_relative './promotion_move'

# Module for making moves objects depending on coordinates and board passed
module MoveCreator
  # Creates a move for the game
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  # @return [Move] a Move object for the passed coordinates in the passed +board+
  def create_move(from, to, board)
    return CastleMove.new(from, to, board) if castle?(from, to, board)

    return CaptureMove.new(from, to, board) if capture?(from, to, board)

    return PromotionMove.new(from, to, board, nil) if promotion?(from, to, board)

    NormalMove.new(from, to, board)
  end

  # Detects if it's a castle move
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def castle?(from, to, board)
    castle_distance = [[0, 2], [0, -2]]
    return true if board.get_piece_at(from).is_a?(King) && castle_distance.include?(board.calculate_distance_vector(
                                                                                      from, to
                                                                                    ))

    false
  end

  # Detects if it's a promotion move
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def promotion?(from, _to, board)
    from_piece = board.get_piece_at(from)
    return true if from_piece.color == 'white' && from_piece.is_a?(Pawn) && from[1] == '7'

    return true if from_piece.color == 'black' && from_piece.is_a?(Pawn) && from[1] == '2'

    false
  end

  # Detects if it's a capture move
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def capture?(from, to, board)
    !board.get_piece_at(to).nil? && board.get_piece_at(from).color != board.get_piece_at(to).color
  end

  # Detects if it's an en passant pawn move
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def en_passant?(from, to, board)
    en_passant_distance = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    from_piece = board.get_piece_at(from)

    # For white
    if from_piece.color == 'white' && from[1] == '5' && en_passant_distance.include?(@board.calculate_distance_vector(
                                                                                       from, to
                                                                                     ))

      return true
    end

    # For black
    if from_piece.color == 'black' && from[1] == '4' && en_passant_distance.include?(@board.calculate_distance_vector(
                                                                                       from, to
                                                                                     ))

      return true
    end

    false
  end

  # TODO, add FirstPawnMove Type
end
