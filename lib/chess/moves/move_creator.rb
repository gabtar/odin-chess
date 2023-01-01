# frozen_string_literal: true

require_relative './normal_move'
require_relative './castle_move'
require_relative './capture_move'
require_relative './first_pawn_move'
require_relative './pawn_capture_move'
require_relative './promotion_move'

# Module for making moves objects depending on coordinates and board passed
module MoveCreator
  # Creates a move for the game
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  # @return [Move] a Move object for the passed coordinates in the passed +board+
  def create_move(from, to, board, piece = Queen.new(board.to_move))
    return CastleMove.new(from, to, board) if castle?(from, to, board)

    return PromotionMove.new(from, to, board, piece) if promotion?(from, to, board)

    return PawnCaptureMove.new(from, to, board) if pawn_capture?(from, to, board)

    return EnPassantMove.new(from, to, board) if en_passant?(from, to, board)

    return FirstPawnMove.new(from, to, board) if first_pawn_move?(from, to, board)

    return CaptureMove.new(from, to, board) if capture?(from, to, board)

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
    return false if from_piece.nil?

    return true if from_piece.color == 'white' && from_piece.is_a?(Pawn) && from[1] == '7'

    return true if from_piece.color == 'black' && from_piece.is_a?(Pawn) && from[1] == '2'

    false
  end

  # Detects if it's a Pawn capture move(captures in a diferent direction)
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def pawn_capture?(from, to, board)
    pawn_capture_distances = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

    board.get_piece_at(from).is_a?(Pawn) && !board.get_piece_at(to).nil? && pawn_capture_distances.include?(board.calculate_distance_vector(
                                                                                                              from, to
                                                                                                            ))
  end

  # Detects if it's a capture move
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def capture?(from, to, board)
    !board.get_piece_at(to).nil? && !board.get_piece_at(from).nil? && board.get_piece_at(from).color != board.get_piece_at(to).color && !board.get_piece_at(from).is_a?(Pawn)
  end

  # Detects if it's a first move for a pawn
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def first_pawn_move?(from, to, board)
    return true if board.get_piece_at(from).is_a?(Pawn) && [[2, 0],
                                                            [-2, 0]].include?(board.calculate_distance_vector(from, to))

    false
  end

  # Detects if it's an en passant pawn move
  # @attr from [String] the starting position sqaure
  # @attr to [String] the ending position square
  # @attr board [Board] the board with the position before the move
  def en_passant?(from, to, board)
    from_piece = board.get_piece_at(from)
    return false if from_piece.nil? || !from_piece.is_a?(Pawn)

    en_passant_distance = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    distance = board.calculate_distance_vector(from, to)
    last_move_validation = board.last_move.is_a?(FirstPawnMove)
    from_en_passant_validation = %w[4 5].include?(from[1])

    return true if en_passant_distance.include?(distance) && last_move_validation && from_en_passant_validation

    false
  end
end
