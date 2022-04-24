# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/knight'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Knight do
  describe '#can_move_to?' do
    subject(:black_knight) { described_class.new('black') }
    let(:black_pawn) { Pawn.new('black') }
    let(:board) { Board.new }

    context 'when going from e4 to f6 on a clean board' do
      it 'returns true' do
        board.add_piece(black_knight, 'e4')
        expect(black_knight.can_move_to?(board, 'e4', 'f6')).to be_truthy
      end
    end

    context 'when going from f5 to h4 on with a pawn on h4' do
      it 'returns false' do
        board.add_piece(black_knight, 'f5')
        board.add_piece(black_pawn, 'h4')
        expect(black_knight.can_move_to?(board, 'f5', 'h4')).to be_falsy
      end
    end

    context 'when capturing a pawn from a1 to c2' do
      let(:white_pawn) { Pawn.new('white') }

      it 'returns true' do
        board.add_piece(black_knight, 'a1')
        board.add_piece(white_pawn, 'c2')
        expect(black_knight.can_move_to?(board, 'a1', 'c2')).to be_truthy
      end
    end
  end

  describe '#defends_square??' do
    subject(:black_knight) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }

    context 'when a knight on a2 defends a square on c3' do
      it 'returns true' do
        board.add_piece(black_knight, 'a2')
        expect(black_knight.defends_square?(board, 'a2', 'c3')).to be_truthy
      end
    end

    context 'when a black knight on c5 defends a black pawn on e6' do
      it 'returns ture' do
        board.add_piece(black_knight, 'c5')
        board.add_piece(black_pawn, 'e6')
        expect(black_knight.defends_square?(board, 'c5', 'e6')).to be_truthy
      end
    end

    context 'when a black knight on h8 defends a square with a white pawn on g6' do
      it 'returns ture' do
        board.add_piece(black_knight, 'h8')
        board.add_piece(white_pawn, 'g7')
        expect(black_knight.defends_square?(board, 'h8', 'g6')).to be_truthy
      end
    end
  end
end
