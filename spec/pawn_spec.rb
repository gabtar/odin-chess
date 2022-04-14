# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Pawn do
  describe '#can_move_to?' do
    subject(:black_pawn) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }

    context 'when moving from a2 to a3' do
      it 'returns true' do
        expect(black_pawn.can_move_to?(board, 'a2', 'a3')).to be_truthy
      end
    end

    context 'when moving from a2 to a4' do
      it 'returns true' do
        expect(black_pawn.can_move_to?(board, 'a2', 'a4')).to be_truthy
      end
    end

    context 'when moving from a2 to c4' do
      it 'returns false' do
        expect(black_pawn.can_move_to?(board, 'a2', 'c4')).to be_falsy
      end
    end

    context 'when a pawn on a2 wants to capture a pawn on b3' do
      it 'returns true' do
        board.add_piece(white_pawn, 'b3')
        expect(black_pawn.can_move_to?(board, 'a2', 'b3')).to be_truthy
      end
    end

    context 'when a pawn on b2 wants to capture a pawn on a3' do
      it 'returns true' do
        board.add_piece(white_pawn, 'a3')
        expect(black_pawn.can_move_to?(board, 'b2', 'a3')).to be_truthy
      end
    end

    context 'when a pawn on a2 wants to capture a pawn on h8' do
      it 'returns false' do
        expect(black_pawn.can_move_to?(board, 'a2', 'h8')).to be_falsy
      end
    end
  end
end
