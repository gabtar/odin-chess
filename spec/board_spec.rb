# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'
require_relative '../lib/chess/pieces/rook'
require_relative '../lib/chess/pieces/king'
require_relative '../lib/chess/pieces/bishop'
require_relative '../lib/chess/errors/invalid_coordinate'
require_relative '../lib/chess/errors/illegal_move'

RSpec.describe Board do
  describe '#add_piece' do
    subject(:board) { described_class.new }
    let(:black_pawn) { instance_double(Pawn) }

    context 'when adding a piece to a1 square' do
      it 'adds the piece to the board in the a1 square' do
        # c4 - rank 4, file c
        board.add_piece(black_pawn, 'c4')
        # file c -> column 2, rank 4 -> row 3 (array index starts from 0)
        # Internally on the squares array of 8x8
        # squares[rank][file]
        expect(board.squares[3][2]).to eq(black_pawn)
      end
    end

    context 'when adding a piece to a non existent square' do
      it 'dont add the piece to the board and raises an InvalidCoordinateError' do
        expect { board.add_piece(black_pawn, 'z5') }.to raise_error(InvalidCoordinateError)
        expect(board.squares[0][0]).to eq(nil)
      end
    end
  end

  describe '#get_piece_at' do
    subject(:board) { described_class.new }
    let(:black_pawn) { instance_double(Pawn) }

    context 'when adding a piece to a1 square' do
      it 'adds the piece to the board in the a1 square' do
        board.add_piece(black_pawn, 'c4')
        expect(board.get_piece_at('c4')).to eql(black_pawn)
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
    let(:black_pawn) { instance_double(Pawn) }

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

  describe '#path_attacked?' do
    subject(:board) { described_class.new }
    let(:black_bishop) { Bishop.new('black') }
    let(:white_king) { King.new('white') }
    let(:white_rook) { Rook.new('white') }

    context 'when the path is not attacked' do
      it 'returns false' do
        board.add_piece(white_king, 'e1')
        board.add_piece(white_rook, 'h1')
        expect(board.path_attacked?('e1', 'g1', 'white')).to be_falsy
      end
    end

    context 'when the path is attacked' do
      it 'returns true' do
        board.add_piece(black_bishop, 'e4')
        board.add_piece(white_king, 'e1')
        board.add_piece(white_rook, 'a1')
        expect(board.path_attacked?('e1', 'a1', 'white')).to be_truthy
      end
    end
  end

  describe '#in_check?' do
    subject(:board) { described_class.new }
    let(:black_king) { King.new('black') }
    let(:white_pawn) { Pawn.new('white') }
    let(:white_bishop) { Bishop.new('white') }

    context 'when the black king is not in check' do
      it 'returns false' do
        board.add_piece(black_king, 'e8')
        board.add_piece(white_pawn, 'a8')
        expect(board.in_check?('black')).to be_falsy
      end
    end

    context 'when the black king is in check' do
      it 'returns true' do
        board.add_piece(black_king, 'e8')
        board.add_piece(white_pawn, 'f7')
        expect(board.in_check?('black')).to be_truthy
      end
    end
  end

  describe '#to_fen' do
    subject(:board) { described_class.new }
    let(:black_king) { King.new('black') }
    let(:white_king) { King.new('white') }
    let(:white_rook) { Rook.new('white') }
    let(:black_rook) { Rook.new('black') }

    context 'when there no pieces in the board' do
      it 'returns 8/8/8/8/8/8/8/8 w -' do
        expect(board.to_fen).to eq('8/8/8/8/8/8/8/8 w - -')
      end
    end

    context 'when there are a white king on e1 and a black king on e8' do
      it 'returns r3k3/8/8/8/8/8/8/4K2R w Kq -' do
        board.add_piece(black_king, 'e8')
        board.add_piece(white_king, 'e1')
        board.add_piece(white_rook, 'h1')
        board.add_piece(black_rook, 'a8')
        expect(board.to_fen).to eq('r3k3/8/8/8/8/8/8/4K2R w Kq -')
      end
    end
  end

  describe '#pieces' do
    subject(:board) { described_class.new }
    let(:black_pawn) { instance_double(Pawn) }
    let(:black_king) { instance_double(King) }
    let(:white_bishop) { instance_double(Bishop) }

    context 'when there are a black pawn and a black king in the board' do
      it 'returns an array of with the black pawn a the black king' do
        board.add_piece(black_king, 'e8')
        board.add_piece(black_pawn, 'e7')
        allow(black_pawn).to receive(:color).and_return('black')
        allow(black_king).to receive(:color).and_return('black')
        expect(board.pieces('black')).to include(black_pawn, black_king)
      end
    end

    context 'when there are a black pawn and a black king in the board and a white bishop' do
      it 'returns an array of with the black pawn a the black king' do
        board.add_piece(black_king, 'e8')
        board.add_piece(black_pawn, 'e7')
        allow(black_pawn).to receive(:color).and_return('black')
        allow(black_king).to receive(:color).and_return('black')
        allow(white_bishop).to receive(:color).and_return('white')
        black_pieces = board.pieces('black')
        expect(black_pieces).to include(black_pawn, black_king)
        expect(black_pieces).not_to include(white_bishop)
      end
    end
  end
end
