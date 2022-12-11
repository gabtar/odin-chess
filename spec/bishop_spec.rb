# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/bishop'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Bishop do
  describe '#can_move_to?' do
    subject(:black_bishop) { described_class.new('black') }
    let(:board) { instance_double(Board) }
    let(:white_pawn) { instance_double(Pawn) }
    let(:bishop_valid_direction_vector) { [1, 1] }
    let(:bishop_invalid_direction_vector) { [0, 1] }

    context 'when moving from a1 to h8' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('a1', 'h8').and_return(bishop_valid_direction_vector)
        expect(black_bishop.can_move_to?(board, 'a1', 'h8')).to be_truthy
      end
    end

    context 'when moving from a1 to a8' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('a1',
                                                                  'a8').and_return(bishop_invalid_direction_vector)
        expect(black_bishop.can_move_to?(board, 'a1', 'a8')).to be_falsy
      end
    end

    context 'when capturing from c1 to h6 with a white pawn on h6' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('c1', 'h6').and_return(bishop_valid_direction_vector)
        expect(black_bishop.can_move_to?(board, 'c1', 'h6')).to be_truthy
      end
    end
  end
end
