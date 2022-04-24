# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/bishop'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Bishop do
  describe '#can_move_to?' do
    subject(:black_bishop) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }

    context 'when moving from a1 to h8' do
      it 'returns true' do
        expect(black_bishop.can_move_to?(board, 'a1', 'h8')).to be_truthy
      end
    end

    context 'when moving from a1 to a8' do
      it 'returns false' do
        expect(black_bishop.can_move_to?(board, 'a1', 'a8')).to be_falsy
      end
    end

    context 'when moving from c8 to g4' do
      it 'returns false' do
        expect(black_bishop.can_move_to?(board, 'c8', 'g4')).to be_truthy
      end
    end

    context 'when capturing from c1 to h6 with a white pawn on h6' do
      it 'returns true' do
        board.add_piece(white_pawn, 'h6')
        expect(black_bishop.can_move_to?(board, 'c1', 'h6')).to be_truthy
      end
    end

    context 'when trying to capture from b7 to f3 with a with a white pawn blocking on d5' do
      it 'returns false' do
        board.add_piece(white_pawn, 'd5')
        expect(black_bishop.can_move_to?(board, 'b7', 'f3')).to be_falsy
      end
    end
  end

  describe '#defends_square?' do
    subject(:black_bishop) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }

    context 'when defends c6 square from f3 in a clean board' do
      it 'returns true' do
        board.add_piece(black_bishop, 'c6')
        expect(black_bishop.defends_square?(board, 'f3', 'c6')).to be_truthy
      end
    end

    context 'when not defends a1 square from h8 by a pawn blocking on d4' do
      it 'returns false' do
        board.add_piece(black_bishop, 'h8')
        board.add_piece(white_pawn, 'd4')
        expect(black_bishop.defends_square?(board, 'h8', 'a1')).to be_falsy
      end
    end
  end
end
