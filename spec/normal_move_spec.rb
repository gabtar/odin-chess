# frozen_string_literal: true

require_relative '../lib/chess/moves/normal_move'
require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/knight'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe NormalMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e4' do
      it 'moves the pawn in the board from e2 to e4' do
        board.add_piece(white_pawn, 'e2')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        move = NormalMove.new('e2', 'e4', board)
        move.execute
        expect(board.get_piece_at('e4')).to eq(white_pawn)
      end
    end
  end

  describe '#validate' do
    let(:board) { Board.new }
    let(:white_knight) { instance_double('Knight') }
    let(:pawn) { instance_double('Pawn') }

    context 'when validating a normal knight move from d4 to e6' do
      it 'does not raises IllegalMoveError' do
        board.add_piece(white_knight, 'd4')
        allow(white_knight).to receive(:is_a?).and_return(Knight)
        allow(white_knight).to receive(:can_move_to?).with(board, 'd4', 'e6').and_return(true)
        allow(white_knight).to receive(:fen_representation).and_return('K')
        move = NormalMove.new('d4', 'e6', board)
        expect { move.validate }.not_to raise_error
      end
    end

    context 'when validating a normal pawn move from e2 to d3' do
      it 'raises IllegalMoveError' do
        board.add_piece(white_knight, 'd4')
        allow(pawn).to receive(:is_a?).and_return(Pawn)
        allow(pawn).to receive(:can_move_to?).with(board, 'e2', 'd3').and_return(false)
        allow(pawn).to receive(:fen_representation).and_return('P')
        allow(white_knight).to receive(:fen_representation).and_return('K')
        move = NormalMove.new('e2', 'd3', board)
        expect { move.validate }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e4' do
      it 'returns e2e4' do
        board.add_piece(white_pawn, 'e2')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        move = NormalMove.new('e2', 'e4', board)
        expect(move.long_algebraic_notation).to eq("#{white_pawn}e2e4")
      end
    end
  end
end
