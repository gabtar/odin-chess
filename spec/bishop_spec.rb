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
        allow(board).to receive(:get_piece_at).with('h8').and_return(nil)
        allow(board).to receive(:blocked_path?).with('a1', 'h8').and_return(false)
        expect(black_bishop.can_move_to?(board, 'a1', 'h8')).to be_truthy
      end
    end

    context 'when moving from a1 to a8' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('a1', 'a8').and_return(bishop_invalid_direction_vector)
        allow(board).to receive(:get_piece_at).with('a8').and_return(nil)
        expect(black_bishop.can_move_to?(board, 'a1', 'a8')).to be_falsy
      end
    end

    context 'when moving from c8 to g4 with a path blocked' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('c8', 'g4').and_return(bishop_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('g4').and_return(nil)
        allow(board).to receive(:blocked_path?).with('c8', 'g4').and_return(true)
        expect(black_bishop.can_move_to?(board, 'c8', 'g4')).to be_falsy
      end
    end

    context 'when capturing from c1 to h6 with a white pawn on h6' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('c1', 'h6').and_return(bishop_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('h6').and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return('white')
        allow(board).to receive(:blocked_path?).with('c1', 'h6').and_return(false)
        expect(black_bishop.can_move_to?(board, 'c1', 'h6')).to be_truthy
      end
    end

    context 'when trying to capture from b7 to f3 with a with a white pawn blocking on d5' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('b7', 'f3').and_return(bishop_valid_direction_vector)
        allow(board).to receive(:get_piece_at).with('f3').and_return(nil)
        allow(board).to receive(:blocked_path?).with('b7', 'f3').and_return(true)
        expect(black_bishop.can_move_to?(board, 'b7', 'f3')).to be_falsy
      end
    end
  end

  describe '#defends_square?' do
    subject(:black_bishop) { described_class.new('black') }
    let(:board) { instance_double(Board) }
    let(:bishop_valid_direction_vector) { [1, 1] }
    let(:bishop_invalid_direction_vector) { [0, 1] }

    context 'when defends c6 square from f3 in a clean board' do
      it 'returns true' do
        allow(board).to receive(:calculate_direction_vector).with('f3', 'c6').and_return(bishop_valid_direction_vector)
        allow(board).to receive(:blocked_path?).with('f3', 'c6').and_return(false)
        expect(black_bishop.defends_square?(board, 'f3', 'c6')).to be_truthy
      end
    end

    context 'when not defends a1 square from h8 by a pawn blocking on d4' do
      it 'returns false' do
        allow(board).to receive(:calculate_direction_vector).with('h8', 'a1').and_return(bishop_valid_direction_vector)
        allow(board).to receive(:blocked_path?).with('h8', 'a1').and_return(true)
        expect(black_bishop.defends_square?(board, 'h8', 'a1')).to be_falsy
      end
    end
  end
end
