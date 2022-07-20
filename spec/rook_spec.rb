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
    let(:rook_invalid_direction_vector) { [0, 1] }

    context 'when moving from b1 to b5 in a clean position' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('b1', 'b5').and_return(rook_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('b5').and_return(nil)
        allow(board).to receive(:blocked_path?).with('b1', 'b5').and_return(false)
        expect(black_rook.can_move_to?(board, 'b1', 'b5')).to be_truthy
      end
    end

    context 'when moving from h8 to d4 in a clean position' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('h8', 'd4').and_return(rook_invalid_direction_vector)
        allow(board).to receive(:get_piece_at).with('d4').and_return(nil)
        expect(black_rook.can_move_to?(board, 'h8', 'd4')).to be_falsy
      end
    end

    context 'when moving from f1 to a1 with a blocked path by a same color pawn on a1' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('f1', 'a1').and_return(rook_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('a1').and_return(nil)
        allow(board).to receive(:blocked_path?).with('f1', 'a1').and_return(true)
        expect(black_rook.can_move_to?(board, 'f1', 'a1')).to be_falsy
      end
    end

    context 'when capturing from c4 to c8 with a opposite color pawn on c8' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('c4', 'c8').and_return(rook_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('c8').and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return('white')
        allow(board).to receive(:blocked_path?).with('c4', 'c8').and_return(false)
        expect(black_rook.can_move_to?(board, 'c4', 'c8')).to be_truthy
      end
    end

    context 'when moving from h2 to h8 with a blocked path by an opposite color pawn on h3' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('h2', 'h8').and_return(rook_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('h8').and_return(nil)
        allow(board).to receive(:blocked_path?).with('h2', 'h8').and_return(true)
        expect(black_rook.can_move_to?(board, 'h2', 'h8')).to be_falsy
      end
    end
  end

  describe '#defends_square?' do
    subject(:black_rook) { Rook.new('black') }
    let(:board) { instance_double(Board) }
    let(:black_pawn) { instance_double(Pawn) }
    let(:rook_valid_direction_vector) { [1, 0] }
    let(:rook_invalid_direction_vector) { [0, 1] }

    context 'when on e6 on a clean board defends e1' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('e6', 'e1').and_return(rook_valid_direction_vector)
        allow(board).to receive(:blocked_path?).with('e6', 'e1').and_return(false)
        expect(black_rook.defends_square?(board, 'e6', 'e1')).to be_truthy
      end
    end

    context 'when on f6 cant defend a6 beacuse of a pawn blocking on b6' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('f6', 'a6').and_return(rook_valid_direction_vector)
        allow(board).to receive(:blocked_path?).with('f6', 'a6').and_return(true)
        expect(black_rook.defends_square?(board, 'f6', 'a6')).to be_falsy
      end
    end
  end
end
