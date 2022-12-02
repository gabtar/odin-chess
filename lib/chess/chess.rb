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
    validate_move(move.from, move.to)
    move.validate
    move.execute
    @moves_list << move
    switch_turn
  end

  # Validates if the passed move +from+ square +to+ square is a legal chess move
  # @param from [String] the starting square
  # @param to [String] the destination square
  def validate_move(from, to)
    # move = Move.new(from, to, @board)
    #
    # raise IllegalMoveError.new('Invalid piece') if piece_to_move.nil? || piece_to_move.color != @turn
    # #
    # # TODO validate with move types?
    # raise IllegalMoveError.new('Illegal piece move') unless piece_to_move.can_move_to?(@board, from, to)

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
  def checkmate?
    checkmate = false
    if @board.in_check?(@turn)
      checkmate = true
      coordinates = []
      8.times do |number|
        coordinates << ('a'..'h').to_a.map! { |rank| rank + (number + 1).to_s }
      end
      coordinates.flatten.each do |from|
        piece = @board.get_piece_at(from)

        next if piece.nil? || piece.color != @turn

        coordinates.flatten.each do |to|
          next if from == to

          begin
            validate_move(from, to)
            move = create_move(from, to, @board)
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
                   permitted_classes: [Chess, Board, Move, Player, Pawn, Knight, Rook, Bishop, King, Queen, NormalMove, PromotionMove, CaptureMove, CastleMove], aliases: true)
  end

  private

  # Validates that the passed move will not result in check for own King
  # @param from [String] the starting square
  # @param to [String] the destination square
  # @return [Boolean] if the moves puts own king in check
  def will_put_my_king_in_check(from, to)
    board_clone = DeepClone.clone(@board)
    from_piece = board_clone.get_piece_at(from)

    board_clone.add_piece(nil, from)
    board_clone.add_piece(from_piece, to)

    board_clone.in_check?(from_piece.color)
  end
end
