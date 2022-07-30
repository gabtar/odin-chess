# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'
require_relative '../lib/chess/pieces/king'
require_relative '../lib/chess/pieces/bishop'

RSpec.describe King do
  describe '#can_move_to?' do
    subject(:black_king) { described_class.new('black') }
    let(:board) { instance_double(Board) }
    let(:pawn) { instance_double(Pawn) }
    let(:valid_king_move) { [1, 1] }
    let(:invalid_king_move) { [3, 1] }

    context 'when moving from e1 to e2 in a clean board' do
      it 'returns true' do
        allow(board).to receive(:calculate_distance_vector).with('e1', 'e2').and_return(valid_king_move)
        allow(board).to receive(:get_piece_at).with('e2').and_return(nil)
        allow(board).to receive(:blocked_path?).with('e1', 'e2').and_return(false)
        expect(black_king.can_move_to?(board, 'e1', 'e2')).to be_truthy
      end
    end

    context 'when moving from d3 to a1 in a clean board' do
      it 'returns false' do
        allow(board).to receive(:calculate_distance_vector).with('d3', 'a1').and_return(invalid_king_move)
        allow(board).to receive(:get_piece_at).with('a1').and_return(nil)
        allow(board).to receive(:blocked_path?).with('d3', 'a1').and_return(false)
        expect(black_king.can_move_to?(board, 'd3', 'a1')).to be_falsy
      end
    end

    context 'when moving from e8 to d7 with a pawn of same color blocking on d7' do
      it 'returns false' do
        allow(board).to receive(:calculate_distance_vector).with('e8', 'd7').and_return(valid_king_move)
        allow(board).to receive(:get_piece_at).with('d7').and_return(pawn)
        allow(pawn).to receive(:color).and_return('black')
        allow(board).to receive(:blocked_path?).with('e8', 'd7').and_return(false)
        expect(black_king.can_move_to?(board, 'e8', 'd7')).to be_falsy
      end
    end

    context 'when trying to capture from g8 to an undefended pawn on h7' do
      it 'returns true' do
        allow(board).to receive(:calculate_distance_vector).with('g8', 'h7').and_return(valid_king_move)
        allow(board).to receive(:get_piece_at).with('h7').and_return(pawn)
        allow(pawn).to receive(:color).and_return('white')
        allow(board).to receive(:blocked_path?).with('g8', 'h7').and_return(false)
        expect(black_king.can_move_to?(board, 'g8', 'h7')).to be_truthy
      end
    end
  end
end
