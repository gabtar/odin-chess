# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/piece'
require_relative '../lib/chess/pieces/pawn'
require_relative '../lib/chess/errors/invalid_coordinate'
require_relative '../lib/chess/errors/illegal_move'

RSpec.describe Board do
  describe '#add_piece' do
    subject(:board) { described_class.new }
    let(:black_piece) { Piece.new('black') }

    context 'when adding a piece to a1 square' do
      it 'adds the piece to the board in the a1 square' do
        # c4 - rank 4, file c
        board.add_piece(black_piece, 'c4')
        # file c -> column 2, rank 4 -> row 3 (array index starts from 0)
        # Internally on the squares array of 8x8
        # squares[rank][file]
        expect(board.squares[3][2]).to eq(black_piece)
      end
    end

    context 'when adding a piece to a non existent square' do
      it 'dont add the piece to the board and raises an InvalidCoordinateError' do
        expect { board.add_piece(black_piece, 'z5') }.to raise_error(InvalidCoordinateError)
        expect(board.squares[0][0]).to eq(nil)
      end
    end
  end

  describe '#calculate_distance_vector' do
    subject(:board) { described_class.new }

    context 'when calculating from a1 to a2' do
      it 'returns [1,0]' do
        expect(board.calculate_distance_vector('a1', 'a2')).to eql([1, 0])
      end
    end

    context 'when calculating from a2 to a1' do
      it 'returns [-1,0]' do
        expect(board.calculate_distance_vector('a2', 'a1')).to eql([-1, 0])
      end
    end

    context 'when calculating from f4 to h4' do
      it 'returns [0,2]' do
        expect(board.calculate_distance_vector('f4', 'h4')).to eql([0, 2])
      end
    end

    context 'when calculating from f8 to b4' do
      it 'returns [-4,-4]' do
        expect(board.calculate_distance_vector('f8', 'b4')).to eql([-4, -4])
      end
    end
  end

  describe '#calculate_direction_vector' do
    subject(:board) { described_class.new }

    context 'when calculating from b3 to b8' do
      it 'returns [1, 0]' do
        expect(board.calculate_direction_vector('b3', 'b8')).to eql([1, 0])
      end
    end

    context 'when calculating from b3 to d5' do
      it 'returns [1, 1]' do
        expect(board.calculate_direction_vector('b3', 'd5')).to eql([1, 1])
      end
    end

    context 'when calculating from b3 to d3' do
      it 'returns [1, 1]' do
        expect(board.calculate_direction_vector('b3', 'd3')).to eql([0, 1])
      end
    end

    context 'when calculating from b3 to c2' do
      it 'returns [-1, 1]' do
        expect(board.calculate_direction_vector('b3', 'c2')).to eql([-1, 1])
      end
    end

    context 'when calculating from b3 to b1' do
      it 'returns [-1, 0]' do
        expect(board.calculate_direction_vector('b3', 'b1')).to eql([-1, 0])
      end
    end

    context 'when calculating from b3 to a2' do
      it 'returns [-1, -1]' do
        expect(board.calculate_direction_vector('b3', 'a2')).to eql([-1, -1])
      end
    end

    context 'when calculating from b3 to a3' do
      it 'returns [0, -1]' do
        expect(board.calculate_direction_vector('b3', 'a3')).to eql([0, -1])
      end
    end

    context 'when calculating from b3 to a4' do
      it 'returns [1, -1]' do
        expect(board.calculate_direction_vector('b3', 'a4')).to eql([1, -1])
      end
    end

    context 'when calculating from b3 to a5' do
      it 'raises IllegalMoveError' do
        expect { board.calculate_direction_vector('b3', 'a5') }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#blocked_path?' do
    subject(:board) { described_class.new }
    let(:black_pawn) { Pawn.new('black') }
    let(:black_pawn_two) { Pawn.new('white') }

    context 'when checking from a1 to a3 in a clean board' do
      it 'returns false' do
        expect(board.blocked_path?('a1', 'a3')).to eql(false)
      end
    end

    context 'when checking from a1 to h8 in a clean board' do
      it 'returns false' do
        expect(board.blocked_path?('a1', 'a8')).to eql(false)
      end
    end

    # Illegal move direction of a piece
    context 'when checking from a1 to b8 in a clean board' do
      it 'raises IllegalMoveError' do
        expect { board.blocked_path?('a1', 'b8') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when checking from d3 to g6 with a pawn blocking on f5' do
      it 'returns true' do
        board.add_piece(black_pawn, 'f5')
        expect(board.blocked_path?('d3', 'g6')).to eql(true)
      end
    end
  end

  describe '#validate_move' do
    subject(:board) { described_class.new }
    let(:black_pawn) { Pawn.new('black') }
    let(:black_pawn_two) { Pawn.new('white') }
    let(:white_pawn) { Pawn.new('white') }

    context 'when moving a pawn from a2 to a4, in a clean board' do
      it 'does not raise IllegalMoveError' do
        board.add_piece(black_pawn, 'a2')
        expect { board.validate_move('a2', 'a4') }.not_to raise_error
      end
    end

    context 'when moving a pawn from a2 to c5, in a clean board' do
      it 'raises IllegalMoveError' do
        board.add_piece(black_pawn, 'a2')
        expect { board.validate_move('a2', 'c5') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when moving a pawn from a2 to a4, with a black pawn on a3' do
      it 'raises IllegalMoveError' do
        board.add_piece(black_pawn, 'a2')
        board.add_piece(black_pawn_two, 'a3')
        expect { board.validate_move('a2', 'a4') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when moving a pawn from a2 to a4, with a black pawn on a4' do
      it 'raises IllegalMoveError' do
        board.add_piece(black_pawn, 'a2')
        board.add_piece(black_pawn_two, 'a4')
        expect { board.validate_move('a2', 'a4') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when capturing a pawn black pawn on b3 with a white pawn placed on a2' do
      it 'does not raises error' do
        board.add_piece(white_pawn, 'a2')
        board.add_piece(black_pawn, 'b3')
        expect { board.validate_move('a2', 'b3') }.not_to raise_error
      end
    end
  end
end
