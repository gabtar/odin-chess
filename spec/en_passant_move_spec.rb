# frozen_string_literal: true

require_relative '../lib/chess/moves/en_passant_move'

RSpec.describe EnPassantMove do
  describe '#execute' do
    let(:board) { Board.new }
    let(:last_move_board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_pawn) { instance_double('Pawn') }

    context 'when capturing en passant from e4 to d3 as black' do
      it 'moves the black pawn from e4 to d3 and removes the white pawn at d4' do
        last_move_board.add_piece(white_pawn, 'd2')
        allow(white_pawn).to receive(:color).and_return('white')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        allow(black_pawn).to receive(:fen_representation).and_return('p')
        board.add_piece(black_pawn, 'e4')
        board.add_piece(white_pawn, 'd4')
        board.last_move = FirstPawnMove.new('d2', 'd4', last_move_board)
        move = EnPassantMove.new('e4', 'd3', board)
        move.execute
        expect(board.get_piece_at('d3')).to eq(black_pawn)
        expect(board.get_piece_at('d4')).to be_nil
      end
    end
  end

  describe '#validate' do
    let(:move) { described_class.new('f5', 'g6', board) }
    let(:board) { Board.new }
    let(:last_move_board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_pawn) { instance_double('Pawn') }

    before :each do
      allow(white_pawn).to receive(:fen_representation).and_return('P')
      allow(black_pawn).to receive(:fen_representation).and_return('p')
    end

    context 'when its not after a first pawn move' do
      it 'raises IllegalMoveError' do
        allow(board).to receive(:get_piece_at).with('f5').and_return(white_pawn)
        allow(board).to receive(:get_piece_at).with('g6').and_return(nil)
        allow(board).to receive(:to_fen).and_return('')
        allow(board).to receive(:last_move).and_return(NormalMove.new('f5', 'g6', board))

        expect { move.validate }.to raise_error(IllegalMoveError)
      end
    end

    context 'when its after a first pawn move but to a wrong square' do
      it 'raises IllegalMoveError' do
        last_move_board.add_piece(white_pawn, 'e7')
        allow(white_pawn).to receive(:color).and_return('white')
        allow(board).to receive(:get_piece_at).with('f5').and_return(white_pawn)
        allow(board).to receive(:get_piece_at).with('g6').and_return(nil)
        allow(board).to receive(:get_piece_at).with('e7').and_return(black_pawn)
        allow(board).to receive(:get_piece_at).with('e5').and_return(nil)
        allow(board).to receive(:to_fen).and_return('')
        allow(board).to receive(:last_move).and_return(FirstPawnMove.new('e7', 'e5', last_move_board))

        expect { move.validate }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#long_algebraic_notation' do
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_pawn) { instance_double('Pawn') }
    context 'when moving from e4 to d3' do
      it 'returns e2xd3e.p.' do
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        allow(black_pawn).to receive(:fen_representation).and_return('p')
        board.add_piece(black_pawn, 'e4')
        move = EnPassantMove.new('e4', 'd3', board)
        expect(move.long_algebraic_notation).to eq('e4xd3e.p.')
      end
    end
  end
end
