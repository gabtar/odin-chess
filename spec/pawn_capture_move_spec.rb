# frozen_string_literal: true

require_relative '../lib/chess/moves/pawn_capture_move'
require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/knight'

RSpec.describe PawnCaptureMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:white_knight) { instance_double('Knight') }

    context 'when moving from e2 to e4' do
      it 'moves the pawn in the board from e2 to d3 and removes the piece at d3' do
        board.add_piece(white_pawn, 'e2')
        allow(white_pawn).to receive(:color).and_return('white')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        move = PawnCaptureMove.new('e2', 'd3', board)
        move.execute
        expect(board.get_piece_at('d3')).to eq(white_pawn)
        expect(board.get_piece_at('e2')).to be_nil
      end
    end
  end

  describe '#validate' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_knight) { instance_double('Knight') }

    context 'when validate capturing a bishop on a4 from b3' do
      it 'does not raises IllegalMoveError' do
        board.add_piece(black_knight, 'a4')
        allow(black_knight).to receive(:fen_representation).and_return('k')
        board.add_piece(white_pawn, 'b3')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        allow(white_pawn).to receive(:color).and_return('white')
        allow(black_knight).to receive(:color).and_return('black')
        allow(white_pawn).to receive(:can_move_to?).with(board, 'b3', 'a4').and_return(true)
        move = PawnCaptureMove.new('b3', 'a4', board)
        expect { move.validate }.not_to raise_error
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when capturing from e2 to d3' do
      it 'returns e2e4' do
        board.add_piece(white_pawn, 'e2')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        move = PawnCaptureMove.new('e2', 'd3', board)
        expect(move.long_algebraic_notation).to eq('e2xd3')
      end
    end
  end
end
