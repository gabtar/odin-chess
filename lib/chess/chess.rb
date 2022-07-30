# frozen_string_literal: true

require 'deep_clone'
require 'yaml'

require_relative './pieces/knight'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/pawn'
require_relative './pieces/rook'

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

  # Adds a move to the current game
  # @param from [String] the starting square
  # @param to [String] the destination square
  def add_move(from, to)
    validate_move(from, to)
    @moves_list << [from, to]
  end

  # Validates if the passed move +from+ square +to+ square is a legal chess move
  # @param from [String] the starting square
  # @param to [String] the destination square
  # TODO, must validate for castle and en passant moves
  def validate_move(from, to)
    piece_to_move = @board.get_piece_at(from)

    raise IllegalMoveError if piece_to_move.color != @turn

    raise IllegalMoveError unless piece_to_move.can_move_to?(@board, from, to)

    raise IllegalMoveError if will_put_my_king_in_check(from, to)
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