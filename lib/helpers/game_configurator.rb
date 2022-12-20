# frozen_string_literal: true

require_relative '../chess/chess'
require_relative '../chess/board/board'
require_relative '../chess/player'
require_relative '../chess/computer_player'
require_relative '../chess/pieces/king'
require_relative '../chess/pieces/queen'
require_relative '../chess/pieces/rook'
require_relative '../chess/pieces/bishop'
require_relative '../chess/pieces/knight'
require_relative '../chess/pieces/pawn'

# Module that creates a new game of chess or loads a saved game
module GameConfigurator
  def create_new_game(computer_player: false)
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

    # Players
    white_player = Player.new('white')
    black_player = Player.new('black')

    if computer_player
      computer_army = %w[white black].sample

      white_player = ComputerPlayer.new(computer_army, board) if computer_army == 'white'
      black_player = ComputerPlayer.new(computer_army, board) if computer_army == 'black'
    end

    game = Chess.new(board, white_player, black_player)

    # Make the first move if computer is white
    loop do
      game.add_move(game.turn.play_move) if white_player.is_a?(ComputerPlayer)
      break
    rescue IllegalMoveError
      next
    end

    game
  end

  def load_game(file)
    Chess.unserialize(file)
  end
end
