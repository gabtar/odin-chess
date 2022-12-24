# frozen_string_literal: true

require_relative '../lib/chess/moves/capture_move'

RSpec.describe CaptureMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_pawn) { instance_double('Pawn') }

    context 'when capturing from e2 to e3' do
      it 'moves the pawn in the board from e2 to e3' do
        allow(black_pawn).to receive(:fen_representation).and_return('p')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        board.add_piece(white_pawn, 'e2')
        board.add_piece(black_pawn, 'e3')
        move = CaptureMove.new('e2', 'e3', board)
        move.execute
        expect(board.get_piece_at('e3')).to eq(white_pawn)
        expect(board.get_piece_at('e2')).to be_nil
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e3' do
      it 'returns e2e4' do
        allow(black_pawn).to receive(:fen_representation).and_return('p')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        board.add_piece(white_pawn, 'e2')
        board.add_piece(black_pawn, 'e3')
        move = CaptureMove.new('e2', 'e3', board)
        expect(move.long_algebraic_notation).to eq("#{white_pawn}e2xe3")
      end
    end
  end
end
