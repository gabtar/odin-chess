# frozen_string_literal: true

require_relative '../lib/chess/moves/first_pawn_move'

RSpec.describe FirstPawnMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e4' do
      it 'moves the pawn in the board from e2 to e4' do
        board.add_piece(white_pawn, 'e2')
        move = FirstPawnMove.new('e2', 'e4', board)
        move.execute
        expect(board.get_piece_at('e4')).to eq(white_pawn)
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e4' do
      it 'returns e2e4' do
        board.add_piece(white_pawn, 'e2')
        move = NormalMove.new('e2', 'e4', board)
        expect(move.long_algebraic_notation).to eq("#{white_pawn}e2e4")
      end
    end
  end
end
