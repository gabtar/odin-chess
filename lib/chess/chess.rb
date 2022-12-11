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
require_relative './moves/move_creator'
require_relative './errors/illegal_move'
require_relative './moves/normal_move'
require_relative './moves/castle_move'
require_relative './moves/capture_move'
require_relative './moves/promotion_move'
require_relative './moves/first_pawn_move'
require_relative './moves/en_passant_move'

# Main class for a chess game
#
# @attr board [Board] the board with the current position of the game
# @attr white_player [Player] player asociated with the white army
# @attr black_player [Player] player asociated with the black army
class Chess
  # TODO, Only needed for tests now
  include MoveCreator

  attr_reader :moves_list, :turn, :board

  def initialize(board, white_player, black_player)
    @board = board
    @moves_list = []
    @white_player = white_player
    @black_player = black_player
    @turn = 'white'
  end

  # Adds a valid move to the current game and updates the game status
  # @attr move [Move] the move we want to add to the current game
  def add_move(move)
    move.validate
    validate_move(move.from, move.to)
    move.execute
    @moves_list << move
    @board.last_move = move
    switch_turn
  end

  # Validates if the passed move +from+ square +to+ square is a legal chess move
  # @param from [String] the starting square
  # @param to [String] the destination square
  def validate_move(from, to)
    piece_to_move = @board.get_piece_at(from)

    raise IllegalMoveError, 'Invalid piece' if piece_to_move.nil? || piece_to_move.color != @turn
    raise IllegalMoveError, 'Cannot put king in check' if will_put_my_king_in_check(from, to)
  end

  # Toggles the current player turn to move
  def switch_turn
    @turn = @turn == 'white' ? 'black' : 'white'
  end

  # Saves the current game by serializing object to a YAML string
  # @return [String] the YAML serialized current game
  def serialize
    YAML.dump(self)
  end

  # Checks if the current player is in checkmate
  # @return [Boolean]
  def checkmate?(board, army)
    checkmate = false
    if in_check?(board, army)
      coordinates = []
      8.times do |number|
        coordinates << ('a'..'h').to_a.map! { |rank| rank + (number + 1).to_s }
      end
      coordinates.flatten.each do |from|
        piece = board.get_piece_at(from)

        next if piece.nil? || piece.color != army

        coordinates.flatten.each do |to|
          next if from == to

          # TODO, if queening
          move = create_move(from, to, board)
          begin
            validate_move(from, to)
            move.validate
            return false
          rescue IllegalMoveError
            checkmate = true
          end
        end
      end
    end

    checkmate
  end

  # Loads a chess game previously saved
  # @param yaml_string [String] the string representing the object saved with YAML.dump()
  def self.unserialize(yaml_string)
    YAML.safe_load(yaml_string,
                   permitted_classes: [Chess, Board, Move, Player, Pawn, Knight, Rook, Bishop, King, Queen, NormalMove, PromotionMove, CaptureMove, CastleMove, FirstPawnMove, EnPassantMove], aliases: true)
  end

  # Validates if the passed colour if current player is in check or not in the current position
  # @param army [String] the colour of the side we want to know if it's in check
  # @return [Boolean] true if its in check otherwise false
  def in_check?(board, army)
    board_clone = DeepClone.clone(board)
    king = board_clone.squares.flatten.select { |piece| !piece.nil? && piece.color == army && piece.is_a?(King) }.first

    board_clone.squares.flatten.each do |piece|
      next if piece.nil? || piece.color == army

      # Look for a piece that is attacking the king
      from = board_clone.get_coordinate(piece)
      move = create_move(from, board_clone.get_coordinate(king), board_clone)

      begin
        # Found a move that can capture the king
        move.validate
        return true
      rescue StandardError => e
        # Its an invalid move, so as it cannot be performed, is not in check
        # Continue looking for captures moves
        next
      end
    end

    false
  end

  private

  # Validates that the passed move will not result in check for own King
  # @param from [String] the starting square
  # @param to [String] the destination square
  # @return [Boolean] if the moves puts own king in check
  def will_put_my_king_in_check(from, to)
    board_clone = DeepClone.clone(@board)

    move = create_move(from, to, board_clone)
    begin
      move.validate
      move.execute
      in_check?(board_clone, @turn)
    rescue StandardError => e
      # It's an Illegal move -> cannot be added, so return true for now
      true
    end
  end
end
