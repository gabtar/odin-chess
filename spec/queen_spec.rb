# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/queen'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Queen do
  describe '#can_move_to?' do
    subject(:black_queen) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }

    context 'when moving from a1 to h8' do
      it 'returns true' do
        board.add_piece(black_queen, 'a1')
        expect(black_queen.can_move_to?(board, 'a1', 'h8')).to be_truthy
      end
    end

    context 'when moving in an invalid direction from a1 to b3' do
      it 'raises IllegalMoveError' do
        board.add_piece(black_queen, 'a1')
        expect { black_queen.can_move_to?(board, 'a1', 'b3') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when moving from d4 to f6 in a clean board' do
      it 'returns true' do
        board.add_piece(black_queen, 'd4')
        expect(black_queen.can_move_to?(board, 'd4', 'f6')).to be_truthy
      end
    end

    context 'when moving from d1 to h5 with a same color pawn on g4' do
      it 'returns false' do
        board.add_piece(black_queen, 'd1')
        board.add_piece(black_pawn, 'g4')
        expect(black_queen.can_move_to?(board, 'd1', 'd5')).to be_truthy
      end
    end

    context 'when capturing from e6 to e1 an opponent pawn in a clear board' do
      it 'returns true' do
        board.add_piece(black_queen, 'e6')
        board.add_piece(white_pawn, 'e1')
        expect(black_queen.can_move_to?(board, 'e6', 'e1')).to be_truthy
      end
    end

    context 'when capturing from e6 to e1 an opponent pawn with an oponent pawn on e3' do
      it 'returns true' do
        board.add_piece(black_queen, 'e6')
        board.add_piece(white_pawn, 'e1')
        board.add_piece(white_pawn, 'e3')
        expect(black_queen.can_move_to?(board, 'e6', 'e1')).to be_falsy
      end
    end
  end

  describe '#defends_square?' do
    subject(:black_queen) { described_class.new('black') }
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }

    context 'when on a clean board from c2 defends a4' do
      it 'returns true' do
        board.add_piece(black_queen, 'c2')
        expect(black_queen.defends_square?(board, 'c2', 'a4')).to be_truthy
      end
    end

    context 'when from d2 cant defend h2 because of a pawn blocking on f2' do
      it 'returns false' do
        board.add_piece(black_queen, 'd2')
        board.add_piece(white_pawn, 'f2')
        expect(black_queen.defends_square?(board, 'd2', 'h2')).to be_falsy
      end
    end
  end
end
