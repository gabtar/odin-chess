# frozen_string_literal: true

require_relative '../lib/chess/moves/castle_move'

RSpec.describe CastleMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:king) { instance_double('King') }
    let(:rook) { instance_double('Rook') }

    context 'when castling short for white' do
      it 'moves the king to g1 and the rook to f1' do
        board.add_piece(king, 'e1')
        board.add_piece(rook, 'h1')
        allow(king).to receive(:fen_representation).and_return('K')
        allow(rook).to receive(:fen_representation).and_return('R')
        move = CastleMove.new('e1', 'g1', board)
        move.execute

        expect(board.get_piece_at('g1')).to eq(king)
        expect(board.get_piece_at('f1')).to eq(rook)
      end
    end
  end

  describe '#validate' do
    let(:board) { Board.new }
    let(:king) { King.new('white') }
    let(:rook) { Rook.new('white') }
    let(:bishop) { Bishop.new('Black') }

    context 'when its not a valid castle' do
      it 'does not raises exception' do
        allow(king).to receive(:fen_representation).and_return('K')
        allow(rook).to receive(:fen_representation).and_return('R')
        allow(bishop).to receive(:fen_representation).and_return('B')
        board.add_piece(king, 'e1')
        board.add_piece(rook, 'h1')
        board.add_piece(bishop, 'a6')
        move = CastleMove.new('e1', 'g1', board)
        expect { move.validate }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    before :each do
      allow(white_pawn).to receive(:fen_representation).and_return('P')
    end

    context 'when castling short' do
      it 'returns 0-0' do
        move = CastleMove.new('e1', 'g1', board)
        expect(move.long_algebraic_notation).to eq('0-0')
      end
    end

    context 'when castling long' do
      it 'returns 0-0-0' do
        move = CastleMove.new('e1', 'c1', board)
        expect(move.long_algebraic_notation).to eq('0-0-0')
      end
    end
  end
end
