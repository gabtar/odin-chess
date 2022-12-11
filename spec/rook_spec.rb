# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/rook'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Rook do
  describe '#can_move_to?' do
    subject(:black_rook) { Rook.new('black') }
    let(:board) { instance_double(Board) }
    let(:white_pawn) { instance_double(Pawn) }
    let(:rook_valid_direction_vector) { [1, 0] }
    let(:rook_invalid_direction_vector) { [1, 1] }

    context 'when moving from b1 to b5 in a clean position' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('b1', 'b5').and_return(rook_valid_direction_vector)
        expect(black_rook.can_move_to?(board, 'b1', 'b5')).to be_truthy
      end
    end

    context 'when moving from h8 to d4 in a clean position' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('h8', 'd4').and_return(rook_invalid_direction_vector)
        expect(black_rook.can_move_to?(board, 'h8', 'd4')).to be_falsy
      end
    end

    context 'when capturing from c4 to c8 with a opposite color pawn on c8' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('c4', 'c8').and_return(rook_valid_direction_vector)
        expect(black_rook.can_move_to?(board, 'c4', 'c8')).to be_truthy
      end
    end
  end
end
