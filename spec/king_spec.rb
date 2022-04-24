# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'
require_relative '../lib/chess/pieces/king'
require_relative '../lib/chess/pieces/bishop'

RSpec.describe King do
  describe '#can_move_to?' do
    subject(:black_king) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }

    context 'when moving from e1 to e2 in a clean board' do
      it 'returns true' do
        board.add_piece(black_king, 'e1')
        expect(black_king.can_move_to?(board, 'e1', 'e2')).to be_truthy
      end
    end

    context 'when moving from e1 to d2 in a clean board' do
      it 'returns true' do
        board.add_piece(black_king, 'e1')
        expect(black_king.can_move_to?(board, 'e1', 'd2')).to be_truthy
      end
    end

    context 'when moving from d3 to a1 in a clean board' do
      it 'returns false' do
        board.add_piece(black_king, 'd3')
        expect(black_king.can_move_to?(board, 'd3', 'c1')).to be_falsy
      end
    end

    context 'when moving from e8 to d7 with a pawn of same color blocking on d7' do
      it 'returns false' do
        board.add_piece(black_king, 'e8')
        board.add_piece(black_pawn, 'd7')
        expect(black_king.can_move_to?(board, 'e8', 'd7')).to be_falsy
      end
    end

    context 'when trying to capture from g8 to an undefended pawn on h7' do
      it 'returns true' do
        board.add_piece(black_king, 'g8')
        board.add_piece(white_pawn, 'h7')
        expect(black_king.can_move_to?(board, 'g8', 'h7')).to be_truthy
      end
    end

    context 'when trying to capture from g8 a defended pawn on h7' do
      it 'returns false' do
        board.add_piece(black_king, 'g8')
        board.add_piece(white_pawn, 'h7')
        expect(black_king.can_move_to?(board, 'h7', 'g8')).to be_falsy
      end
    end
  end

  describe '#defends_square?' do
    subject(:white_king) { described_class.new('white') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }
    let(:black_bishop) { Bishop.new('black') }

    context 'when on a clean board from e1 defends f2' do
      it 'returns true' do
        board.add_piece(white_king, 'e1')
        expect(white_king.defends_square?(board, 'e1', 'f2')).to be_truthy
      end
    end

    context 'when on a clean board from e1 not defends h5' do
      it 'returns true' do
        board.add_piece(white_king, 'e1')
        expect(white_king.defends_square?(board, 'e1', 'h5')).to be_falsy
      end
    end

    context 'when a white king on d5, not defends a black pawn on d6 because its defended by a black bishop on f8' do
      it 'returns false' do
        board.add_piece(white_king, 'd5')
        board.add_piece(black_pawn, 'd6')
        board.add_piece(black_bishop, 'f8')
        expect(white_king.defends_square?(board, 'd5', 'd6')).to be_falsy
      end
    end
  end
end
