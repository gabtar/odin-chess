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
require_relative './errors/illegal_move'

# Main class for a chess game
#
# @attr board [Board] the board with the current position of the game
# @attr white_player [Player] player asociated with the white army
# @attr black_player [Player] player asociated with the black army
class Chess
  attr_reader :moves_list, :turn, :board

  def initialize(board, white_player, black_player)
    @board = board
    @moves_list = []
    @white_player = white_player
    @black_player = black_player
    @turn = 'white'
  end

  # Adds a valid move to the current game and updates the game status
  # @param from [String] the starting square
  # @param to [String] the destination square
  # TODO refactor for queening move!!!
  def add_move(from, to)
    validate_move(from, to)

    piece = @board.get_piece_at(from)
    # TODO, add to captured pieces in case of capture
    # TODO, check en passant / castle moves
    @board.add_piece(nil, from)
    @board.add_piece(piece, to)

    # Move should be a class or better a Struct?? and moves list an array of objects?
    # Should have Player, 
    # Struct.new(:from, :to, :piece?, board_before?)
    @moves_list << [from, to]
    switch_turn
  end

  # Validates if the passed move +from+ square +to+ square is a legal chess move
  # @param from [String] the starting square
  # @param to [String] the destination square
  # TODO, must validate for castle and en passant moves
  def validate_move(from, to)
    piece_to_move = @board.get_piece_at(from)

    raise IllegalMoveError.new('Invalid piece') if piece_to_move.nil? || piece_to_move.color != @turn

    raise IllegalMoveError.new('Illegal piece move') unless piece_to_move.can_move_to?(@board, from, to)

    raise IllegalMoveError.new('Cannot put king in check') if will_put_my_king_in_check(from, to)
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
    YAML.safe_load(yaml_string, permitted_classes: [Chess, Board, Player, Pawn, Knight, Rook, Bishop, King, Queen])
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
