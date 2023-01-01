# frozen_string_literal: true

require_relative '../lib/chess/moves/promotion_move'

RSpec.describe PromotionMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e7 to e8' do
      it 'moves the pawn in the board from e7 to e8 and converts to Queen' do
        board.add_piece(white_pawn, 'e7')
        allow(white_pawn).to receive(:color).and_return('white')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        move = PromotionMove.new('e7', 'e8', board, Queen.new('white'))
        move.execute
        expect(board.get_piece_at('e8')).to be_a_kind_of(Queen)
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:pawn) { instance_double('Pawn') }

    context 'when queening from d2 to d1' do
      it 'returns d2d1=♛' do
        board.add_piece(pawn, 'd2')
        allow(pawn).to receive(:color).and_return('black')
        allow(pawn).to receive(:fen_representation).and_return('P')
        move = PromotionMove.new('d2', 'd1', board, Queen.new('black'))
        expect(move.long_algebraic_notation).to eq('d2d1=♕')
      end
    end
  end
end
