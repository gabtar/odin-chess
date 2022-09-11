# frozen_string_literal: true

require_relative './chess/chess'
require_relative './chess/board/board'
require_relative './chess/player'
require_relative './chess/pieces/king'
require_relative './chess/pieces/queen'
require_relative './chess/pieces/rook'
require_relative './chess/pieces/bishop'
require_relative './chess/pieces/knight'
require_relative './chess/pieces/pawn'

# Module that creates a new game of chess or loads a saved game
module GameConfigurator
  def create_new_game
    board = Board.new

    # White army
    ('a'..'h').to_a.each { |rank| board.add_piece(Pawn.new('white'), "#{rank}2") }
    %w[a1 h1].each { |coordinate| board.add_piece(Rook.new('white'), coordinate) }
    %w[b1 g1].each { |coordinate| board.add_piece(Knight.new('white'), coordinate) }
    %w[c1 f1].each { |coordinate| board.add_piece(Bishop.new('white'), coordinate) }
    board.add_piece(Queen.new('white'), 'd1')
    board.add_piece(King.new('white'), 'e1')

    # Black army
    ('a'..'h').to_a.each { |rank| board.add_piece(Pawn.new('black'), "#{rank}7") }
    %w[a8 h8].each { |coordinate| board.add_piece(Rook.new('black'), coordinate) }
    %w[b8 g8].each { |coordinate| board.add_piece(Knight.new('black'), coordinate) }
    %w[c8 f8].each { |coordinate| board.add_piece(Bishop.new('black'), coordinate) }
    board.add_piece(Queen.new('black'), 'd8')
    board.add_piece(King.new('black'), 'e8')

    Chess.new(board, Player.new('white'), Player.new('black'))
  end

  def load_game(file)
    Chess.unserialize(file)
  end
end

# Wrapper for the chess game
# todo add game interface
class Game
  attr_accessor :current_game

  include GameConfigurator

  def initialize
    @current_game = create_new_game
  end

  def new_game
    @current_game = create_new_game
  end

  def load_game(file)
    @current_game = Chess.unserialize(file)
  end

  # Add options for all commands used
  # TODO ADD options for save game, and enter move
  def add_move(from, to)
    @current_game.add_move(from, to)
  end

  def serialize
    @current_game.serialize
  end
end
