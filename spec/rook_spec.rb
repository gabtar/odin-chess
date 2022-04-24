# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/rook'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Rook do
  describe '#can_move_to?' do
    subject(:black_rook) { Rook.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }

    context 'when moving from b1 to b5 in a clean position' do
      it 'returns true' do
        board.add_piece(black_rook, 'b1')
        expect(black_rook.can_move_to?(board, 'b1', 'b5')).to be_truthy
      end
    end

    context 'when moving from h8 to d4 in a clean position' do
      it 'returns false' do
        board.add_piece(black_rook, 'h8')
        expect(black_rook.can_move_to?(board, 'h8', 'd4')).to be_falsy
      end
    end

    context 'when moving from f1 to a1 with a same color pawn on a1' do
      it 'returns false' do
        board.add_piece(black_rook, 'f1')
        board.add_piece(black_pawn, 'a1')
        expect(black_rook.can_move_to?(board, 'f1', 'a1')).to be_falsy
      end
    end

    context 'when capturing from c4 to c8 with a opposite color pawn on c8' do
      it 'returns true' do
        board.add_piece(black_rook, 'c4')
        board.add_piece(white_pawn, 'c8')
        expect(black_rook.can_move_to?(board, 'c4', 'c8')).to be_truthy
      end
    end

    context 'when moving from h2 to h8 with a opposite color pawn on h3' do
      it 'returns false' do
        board.add_piece(black_rook, 'h2')
        board.add_piece(white_pawn, 'h3')
        expect(black_rook.can_move_to?(board, 'h2', 'h8')).to be_falsy
      end
    end
  end

  describe '#defends_square?' do
    subject(:black_rook) { Rook.new('black') }
    let(:board) { Board.new }
    let(:black_pawn) { Pawn.new('black') }

    context 'when on e6 on a clean board defends e1' do
      it 'returns true' do
        board.add_piece(black_rook, 'e6')
        expect(black_rook.defends_square?(board, 'e6', 'e1')).to be_truthy
      end
    end

    context 'when on f6 cant defend a6 beacuse of a pawn blocking on b6' do
      it 'returns false' do
        board.add_piece(black_rook, 'f6')
        board.add_piece(black_pawn, 'b6')
        expect(black_rook.defends_square?(board, 'f6', 'a6')).to be_falsy
      end
    end
  end
end
