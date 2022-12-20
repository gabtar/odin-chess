# frozen_string_literal: true

require_relative '../lib/chess/computer_player'
require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/king'
require_relative '../lib/chess/pieces/pawn'
require_relative '../lib/chess/moves/move_creator'

RSpec.describe ComputerPlayer do
  describe '#play_move' do
    subject(:computer_player) { described_class.new('white', board) }
    let(:board) { Board.new }
    let(:white_king) { King.new('white') }

    context 'when asked for a move in the current board' do
      it 'returns returns a valid move' do
        board.add_piece(white_king, 'e1')

        expect { computer_player.play_move.validate }.not_to raise_error
      end
    end
  end
end
