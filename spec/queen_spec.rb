# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/queen'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Queen do
  describe '#can_move_to?' do
    subject(:black_queen) { described_class.new('black') }
    let(:board) { instance_double(Board) }
    let(:white_pawn) { instance_double(Pawn) }
    let(:black_pawn) { instance_double(Pawn) }
    let(:valid_queen_direction_vector) { [1, 1] }
    let(:invalid_queen_direction_vector) { [2, 1] }

    context 'when moving from a1 to h8' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('a1', 'h8').and_return(valid_queen_direction_vector)
        expect(black_queen.can_move_to?(board, 'a1', 'h8')).to be_truthy
      end
    end

    context 'when moving in an invalid direction from a1 to b3' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('a1', 'b3').and_raise(IllegalMoveError)
        expect(black_queen.can_move_to?(board, 'a1', 'b3')).to be_falsy
      end
    end

    context 'when moving from d4 to f6 in a clean board' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('d4', 'f6').and_return(valid_queen_direction_vector)
        expect(black_queen.can_move_to?(board, 'd4', 'f6')).to be_truthy
      end
    end

    context 'when capturing from e6 to e1 an opponent pawn in a clear board' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('e6', 'e1').and_return(valid_queen_direction_vector)
        expect(black_queen.can_move_to?(board, 'e6', 'e1')).to be_truthy
      end
    end
  end
end
