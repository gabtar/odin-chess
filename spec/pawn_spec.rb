# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Pawn do
  describe '#can_move_to?' do
    subject(:black_pawn) { described_class.new('black') }
    let(:board) { instance_double(Board) }
    let(:white_pawn) { Pawn.new('white') }
    let(:valid_pawn_distance_vector) { [1, 0] }
    let(:valid_pawn_capture_distance) { [1, 1] }
    let(:invalid_pawn_distance_vector) { [3, 0] }

    context 'when moving from a2 to a3' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('a3').and_return(nil)
        allow(board).to receive(:parse_coordinate).with('a2').and_return([2, 0])
        allow(board).to receive(:calculate_distance_vector).with('a2', 'a3').and_return(valid_pawn_distance_vector)
        allow(board).to receive(:blocked_path?).with('a2', 'a3').and_return(false)
        expect(black_pawn.can_move_to?(board, 'a2', 'a3')).to be_truthy
      end
    end

    context 'when moving from a2 to c4' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('c4').and_return(nil)
        allow(board).to receive(:parse_coordinate).with('a2').and_return([2, 0])
        allow(board).to receive(:calculate_distance_vector).with('a2', 'c4').and_return(invalid_pawn_distance_vector)
        allow(board).to receive(:blocked_path?).with('a2', 'c4').and_return(false)
        expect(black_pawn.can_move_to?(board, 'a2', 'c4')).to be_falsy
      end
    end

    context 'when a pawn on a2 wants to capture a pawn on b3' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('b3').and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return('white')
        allow(board).to receive(:parse_coordinate).with('a2').and_return([2, 0])
        allow(board).to receive(:calculate_distance_vector).with('a2', 'b3').and_return(valid_pawn_capture_distance)
        expect(black_pawn.can_move_to?(board, 'a2', 'b3')).to be_truthy
      end
    end

    context 'when a pawn on a2 wants to capture a pawn on h8' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('h8').and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return('white')
        allow(board).to receive(:parse_coordinate).with('a2').and_return([2, 0])
        allow(board).to receive(:calculate_distance_vector).with('a2', 'h8').and_return(invalid_pawn_distance_vector)
        expect(black_pawn.can_move_to?(board, 'a2', 'h8')).to be_falsy
      end
    end
  end

  describe '#defends_square??' do
    subject(:white_pawn) { described_class.new('white') }
    let(:board) { instance_double(Board) }
    let(:valid_pawn_capture_distance) { [1, 1] }
    let(:invalid_pawn_distance_vector) { [3, 0] }

    context 'when a pawn on a2 defends a square on b3' do
      it 'returns ture' do
        allow(board).to receive(:calculate_distance_vector).with('a2', 'b3').and_return(valid_pawn_capture_distance)
        expect(white_pawn.defends_square?(board, 'a2', 'b3')).to be_truthy
      end
    end

    context 'when a pawn on h2 defends a square on g3' do
      it 'returns ture' do
        allow(board).to receive(:calculate_distance_vector).with('h2', 'g3').and_return(valid_pawn_capture_distance)
        expect(white_pawn.defends_square?(board, 'h2', 'g3')).to be_truthy
      end
    end

    context 'when a pawn on h2 not defends a square on a1' do
      it 'returns false' do
        allow(board).to receive(:calculate_distance_vector).with('h2', 'a1').and_return(invalid_pawn_distance_vector)
        expect(white_pawn.defends_square?(board, 'h2', 'a1')).to be_falsy
      end
    end
  end
end
