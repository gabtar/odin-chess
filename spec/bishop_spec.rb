# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/bishop'

RSpec.describe Bishop do
  describe '#can_move?' do
    subject(:black_bishop) { described_class.new('black') }
    let(:board) { Board.new }

    context 'when moving from a1 to h8' do
      it 'returns true' do
        expect(black_bishop.can_move?(board, 'a1', 'h8')).to be_truthy
      end
    end

    context 'when moving from a1 to a8' do
      it 'returns false' do
        expect(black_bishop.can_move?(board, 'a1', 'a8')).to be_falsy
      end
    end

    context 'when moving from c8 to g4' do
      it 'returns false' do
        expect(black_bishop.can_move?(board, 'c8', 'g4')).to be_truthy
      end
    end
  end

  # NOT needed to test because bishop captures in the 
  # same squares he can move to
  # describe '#can_capture?' do
  # end
end
