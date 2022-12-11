# frozen_string_literal: true

require_relative '../lib/chess/moves/first_pawn_move'
require_relative '../lib/chess/board/board'

RSpec.describe FirstPawnMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e4' do
      it 'moves the pawn in the board from e2 to e4' do
        allow(white_pawn).to receive(:color).and_return('white')
        board.add_piece(white_pawn, 'e2')
        move = FirstPawnMove.new('e2', 'e4', board)
        move.execute
        expect(board.get_piece_at('e4')).to eq(white_pawn)
      end
    end
  end

  describe '#validate' do
    let(:board) { instance_double('Board') }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving a white pawn from rank 2' do
      it 'not raises IllegalMoveError' do
        allow(board).to receive(:get_piece_at).with('e2').and_return(white_pawn)
        allow(board).to receive(:get_piece_at).with('e4').and_return(nil)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'e2', 'e4').and_return(true)
        allow(white_pawn).to receive(:color).and_return('white')
        move = FirstPawnMove.new('e2', 'e4', board)

        expect { move.validate }.not_to raise_error
      end
    end

    context 'when moving a white pawn from rank 4' do
      it 'raises IllegalMoveError' do
        allow(board).to receive(:get_piece_at).with('e4').and_return(white_pawn)
        allow(board).to receive(:get_piece_at).with('e6').and_return(nil)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'e4', 'e6').and_return(true)
        allow(white_pawn).to receive(:color).and_return('white')
        move = FirstPawnMove.new('e4', 'e6', board)

        expect { move.validate }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    context 'when moving from e2 to e4' do
      it 'returns e2e4' do
        allow(white_pawn).to receive(:color).and_return('white')
        board.add_piece(white_pawn, 'e2')
        move = FirstPawnMove.new('e2', 'e4', board)
        expect(move.long_algebraic_notation).to eq("#{white_pawn}e2e4")
      end
    end
  end
end
