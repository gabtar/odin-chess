# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Pawn do
  describe '#can_move_to?' do
    subject(:black_pawn) { described_class.new('black') }
    let(:board) { instance_double(Board) }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }
    let(:valid_pawn_distance_vector) { [1, 0] }
    let(:valid_pawn_capture_distance) { [1, 1] }
    let(:invalid_pawn_distance_vector) { [3, 0] }

    context 'when moving from a2 to a3' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('a3').and_return(nil)
        allow(board).to receive(:calculate_distance_vector).with('a2', 'a3').and_return(valid_pawn_distance_vector)
        expect(white_pawn.can_move_to?(board, 'a2', 'a3')).to be_truthy
      end
    end

    context 'when moving from a2 to c4' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('c4').and_return(nil)
        allow(board).to receive(:calculate_distance_vector).with('a2', 'c4').and_return(invalid_pawn_distance_vector)
        expect(black_pawn.can_move_to?(board, 'a2', 'c4')).to be_falsy
      end
    end

    context 'when a pawn on a2 wants to capture a pawn on h8' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('h8').and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return('white')
        allow(board).to receive(:calculate_distance_vector).with('a2', 'h8').and_return(invalid_pawn_distance_vector)
        expect(black_pawn.can_move_to?(board, 'a2', 'h8')).to be_falsy
      end
    end

    context 'when moving from e7 to e5 for black' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('e5').and_return(nil)
        allow(board).to receive(:calculate_distance_vector).with('e7', 'e5').and_return([-1, 0])
        expect(black_pawn.can_move_to?(board, 'e7', 'e5')).to be_truthy
      end
    end
  end
end
