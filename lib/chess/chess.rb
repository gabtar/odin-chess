# frozen_string_literal: true

require 'deep_clone'
require 'yaml'

require_relative './pieces/knight'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/pawn'
require_relative './pieces/rook'
require_relative './board/board'
require_relative './player'
require_relative './computer_player'
require_relative './moves/move_creator'
require_relative './errors/illegal_move'
require_relative './moves/normal_move'
require_relative './moves/castle_move'
require_relative './moves/capture_move'
require_relative './moves/promotion_move'
require_relative './moves/first_pawn_move'
require_relative './moves/pawn_capture_move'
require_relative './moves/en_passant_move'

# Main class for a chess game
#
# @attr board [Board] the board with the current position of the game
# @attr white_player [Player] player asociated with the white army
# @attr black_player [Player] player asociated with the black army
class Chess
  include MoveCreator

  attr_reader :moves_list, :turn, :board, :white_player, :black_player
  attr_accessor :result

  def initialize(board, white_player, black_player)
    @board = board
    @moves_list = []
    @white_player = white_player
    @black_player = black_player
    @turn = @white_player
    @result = nil
  end

  # Adds a valid move to the current game and updates the game status
  # @attr move [Move] the move we want to add to the current game
  def add_move(move)
    move.validate
    validate_move_turn(move)
    validate_not_results_in_check_for_own_king(move)
    # Set if a rook or a king has been moved
    piece_to_move = @board.get_piece_at(move.from)
    piece_to_move.moved = true if piece_to_move.is_a?(King) || piece_to_move.is_a?(Rook)

    move.execute
    generate_notation(move)

    @moves_list << move
    switch_turn
    @board.last_move = move
    @board.to_move = @turn.color
  end

  # Validates if the passed +move+ is of a piece of the current turn player
  # @param move [Move] the move we want to make on the chess board
  def validate_move_turn(move)
    raise IllegalMoveError, 'Invalid piece' if move.from_piece.nil? || move.from_piece.color != @turn.color
  end

  # Validates if the passed +move+ is of a piece of the current turn player
  # @param move [Move] the move we want to make on the chess board
  def validate_not_results_in_check_for_own_king(move)
    raise IllegalMoveError, 'Cannot put king in check' if will_put_my_king_in_check(move)
  end

  # Toggles the current player turn to move
  def switch_turn
    @turn = @turn.color == 'white' ? @black_player : @white_player
  end

  # Saves the current game by serializing object to a YAML string
  # @return [String] the YAML serialized current game
  def serialize
    YAML.dump(self)
  end

  # Checks if the passed +army+ on the passed +board+ is in checkmate
  # (in check and with no legal moves)
  # @return [Boolean]
  def checkmate?(board, army)
    return false unless board.in_check?(army)

    checkmate = false
    coordinates = []
    8.times do |number|
      coordinates << ('a'..'h').to_a.map! { |rank| rank + (number + 1).to_s }
    end

    board.pieces(army).each do |piece|
      from = board.get_coordinate(piece)

      coordinates.flatten.each do |to|
        move = create_move(from, to, board)
        begin
          validate_move_turn(move)
          validate_not_results_in_check_for_own_king(move)
          move.validate
          return false
        rescue IllegalMoveError, InvalidCoordinateError
          checkmate = true
        end
      end
    end

    checkmate
  end

  # Checks if the passed +army+ on the passed +board+ is in stealmate(no legal moves)
  # @return [Boolean]
  def stealmate?(board, army)
    return false if board.in_check?(army)

    stealmate = true
    coordinates = []
    8.times do |number|
      coordinates << ('a'..'h').to_a.map! { |rank| rank + (number + 1).to_s }
    end

    board.pieces(army).each do |piece|
      from = board.get_coordinate(piece)

      coordinates.flatten.each do |to|
        move = create_move(from, to, board)
        begin
          validate_move_turn(move)
          validate_not_results_in_check_for_own_king(move)
          move.validate
          return false
        rescue IllegalMoveError, InvalidCoordinateError
          stealmate = true
        end
      end
    end

    stealmate
  end

  # Validates if last move position is a threefold repetition
  def threefold_repetition?
    # Check if last position has been repeated for at least 3 times
    last_postion = @moves_list.last.fen_string

    @moves_list.select { |move| move.fen_string == last_postion }.length >= 2
  end

  # Detrmines if the passed +board+ position is a draw by insuficient material
  # to checkmate the opponent of both sides
  def insuficient_material?(board)
    # Checks any of these for both sides
    # - A lone king
    # - A king and a bishop
    # - A king and a knight
    white_pieces = board.pieces('white')
    black_pieces = board.pieces('black')

    return true if white_pieces.length == 1 && black_pieces.length == 1
    return false if white_pieces.length > 2 || black_pieces.length > 2

    # One piece must be the king, so the other must be either a bishop or a knight
    black_insuficient_material = !black_pieces.select { |piece| piece.is_a?(Knight) || piece.is_a?(Bishop) }.empty?
    white_insuficient_material = !white_pieces.select { |piece| piece.is_a?(Knight) || piece.is_a?(Bishop) }.empty?

    black_insuficient_material && white_insuficient_material
  end

  # Loads a chess game previously saved
  # @param yaml_string [String] the string representing the object saved with YAML.dump()
  def self.unserialize(yaml_string)
    YAML.safe_load(yaml_string,
                   permitted_classes: [Chess, Board, Move, Player, ComputerPlayer, Pawn, Knight, Rook, Bishop, King, Queen, NormalMove, PromotionMove, CaptureMove, CastleMove, PawnCaptureMove, FirstPawnMove, EnPassantMove], aliases: true)
  end

  private

  # Validates that the passed move will not result in check for own King
  # @param from [String] the starting square
  # @param to [String] the destination square
  # @return [Boolean] if the moves puts own king in check
  def will_put_my_king_in_check(move)
    board_clone = DeepClone.clone(@board)
    move.board = board_clone # We need to perform the move in the board clone

    begin
      move.validate
      move.execute
      move.board = @board # Set the original board
      board_clone.in_check?(@turn.color)
    rescue IllegalMoveError, InvalidCoordinateError
      # It's an Illegal move -> cannot be added
      true
    end
  end

  # Detemines if the move has been result in check or checkmate to the
  # opponent and add the status symbol to the move notation
  # @param move [Move] the move we want to get the notation
  def generate_notation(move)
    switch_turn
    @board.to_move = @turn.color
    check = @board.in_check?(@turn.color) ? '+' : ''
    checkmate = checkmate?(@board, @turn.color) ? '#' : ''

    move.notation = "#{move.long_algebraic_notation}#{checkmate.empty? ? check : checkmate}"
    switch_turn
    @board.to_move = @turn.color
  end
end
