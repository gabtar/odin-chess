# frozen_string_literal: true

require_relative '../lib/chess/chess'
require_relative '../lib/helpers/game_configurator'

RSpec.describe GameConfigurator do
  it 'should create a game with initial chess position' do
    game = Class.new
    game.extend(GameConfigurator)
    chess = game.create_new_game
    board = chess.instance_variable_get(:@board)
    expect(chess).to be_an_instance_of(Chess)
    expect(board.get_piece_at('a2')).to be_an_instance_of(Pawn)
    expect(board.get_piece_at('a1')).to be_an_instance_of(Rook)
    expect(board.get_piece_at('b1')).to be_an_instance_of(Knight)
    expect(board.get_piece_at('c1')).to be_an_instance_of(Bishop)
    expect(board.get_piece_at('d1')).to be_an_instance_of(Queen)
    expect(board.get_piece_at('e1')).to be_an_instance_of(King)
    expect(board.get_piece_at('a7')).to be_an_instance_of(Pawn)
    expect(board.get_piece_at('a8')).to be_an_instance_of(Rook)
    expect(board.get_piece_at('b8')).to be_an_instance_of(Knight)
    expect(board.get_piece_at('c8')).to be_an_instance_of(Bishop)
    expect(board.get_piece_at('d8')).to be_an_instance_of(Queen)
    expect(board.get_piece_at('e8')).to be_an_instance_of(King)
  end
end
