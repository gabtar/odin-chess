# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Pawn do
  describe '#can_move?' do
    subject(:black_pawn) { described_class.new('black') }
    let(:board) { Board.new }

    context 'when moving from a2 to a3' do
      it 'returns true' do
        expect(black_pawn.can_move?(board, 'a2', 'a3')).to be_truthy
      end
    end

    context 'when moving from a2 to a4' do
      it 'returns true' do
        expect(black_pawn.can_move?(board, 'a2', 'a4')).to be_truthy
      end
    end

    context 'when moving from a2 to c4' do
      it 'returns false' do
        expect(black_pawn.can_move?(board, 'a2', 'c4')).to be_falsy
      end
    end
  end
end
