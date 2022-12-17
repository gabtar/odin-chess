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

  def initialize(board, white_player, black_player)
    @board = board
    @moves_list = []
    @white_player = white_player
    @black_player = black_player
    @turn = @white_player
  end

  # Adds a valid move to the current game and updates the game status
  # @attr move [Move] the move we want to add to the current game
  def add_move(move)
    move.validate
    validate_move(move.from, move.to) # TODO, remove from here to move.validate method
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

    raise IllegalMoveError, 'Invalid piece' if piece_to_move.nil? || piece_to_move.color != @turn.color
    raise IllegalMoveError, 'Cannot put king in check' if will_put_my_king_in_check(from, to)
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

  # Checks if the passed +army+ on the passed +board+ is in checkmate(no legal moves)
  # @return [Boolean]
  def checkmate?(board, army)
    checkmate = false
    if board.in_check?(board, army)
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
                   permitted_classes: [Chess, Board, Move, Player, ComputerPlayer, Pawn, Knight, Rook, Bishop, King, Queen, NormalMove, PromotionMove, CaptureMove, CastleMove, PawnCaptureMove, FirstPawnMove, EnPassantMove], aliases: true)
  end

  private

  # Validates that the passed move will not result in check for own King
  # @param from [String] the starting square
  # @param to [String] the destination square
  # @return [Boolean] if the moves puts own king in check
  def will_put_my_king_in_check(from, to)
    board_clone = DeepClone.clone(@board)

    # TODO, check if its a queening move
    move = create_move(from, to, board_clone)
    begin
      move.validate
      move.execute
      board_clone.in_check?(board_clone, @turn.color)
    rescue StandardError => e
      # It's an Illegal move -> cannot be added, so return true for now
      true
    end
  end
end
