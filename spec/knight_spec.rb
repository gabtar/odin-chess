# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/knight'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Knight do
  describe '#can_move_to?' do
    subject(:black_knight) { described_class.new('black') }
    let(:black_pawn) { instance_double(Pawn) }
    let(:board) { instance_double(Board) }

    context 'when going from e4 to f6 on a clean board' do
      it 'returns true' do
        allow(board).to receive(:calculate_distance_vector).with('e4', 'f6').and_return([2, 1])
        allow(board).to receive(:get_piece_at).with('f6').and_return(nil)
        expect(black_knight.can_move_to?(board, 'e4', 'f6')).to be_truthy
      end
    end

    context 'when capturing a pawn from a1 to c2' do
      let(:white_pawn) { instance_double(Pawn) }

      it 'returns true' do
        allow(board).to receive(:calculate_distance_vector).with('a1', 'c2').and_return([1, 2])
        allow(board).to receive(:get_piece_at).with('c2').and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return('white')
        expect(black_knight.can_move_to?(board, 'a1', 'c2')).to be_truthy
      end
    end
  end
end
