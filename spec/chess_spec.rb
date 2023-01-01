# frozen_string_literal: true

require_relative '../lib/chess/board/board'
require_relative '../lib/chess/pieces/pawn'
require_relative '../lib/chess/pieces/king'
require_relative '../lib/chess/pieces/bishop'
require_relative '../lib/chess/chess'
require_relative '../lib/chess/player'

RSpec.describe Chess do
  describe '#add_move' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { instance_double('Player') }
    let(:black_player) { instance_double('Player') }
    let(:board) { Board.new }
    let(:white_pawn) { instance_double('Pawn') }

    before :each do
      allow(white_pawn).to receive(:color).and_return('white')
    end

    context 'when it is a valid move' do
      let(:move) { NormalMove.new('a2', 'a3', board) }

      it 'it adds the move to the game' do
        board.add_piece(white_pawn, 'a2')
        allow(white_pawn).to receive(:can_move_to?).with(any_args).and_return(true)
        allow(white_player).to receive(:color).exactly(5).times.and_return('white')
        allow(black_player).to receive(:color).and_return('black')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        chess.add_move(move)
        expect(chess.moves_list).to have_attributes(size: (be > 0))
      end
    end

    context 'when it is an invalid move' do
      let(:move) { NormalMove.new('a1', 'b5', board) }

      it 'raises IllegalMoveError' do
        board.add_piece(white_pawn, 'a1')
        allow(white_pawn).to receive(:fen_representation).and_return('P')
        allow(white_pawn).to receive(:can_move_to?).with(any_args).and_return(false)
        expect { chess.add_move(move) }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#validate_move' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { instance_double('Player') }
    let(:black_player) { instance_double('Player') }
    let(:board) { instance_double('Board') }
    let(:white_pawn) { instance_double('Pawn') }

    before :each do
      allow(white_pawn).to receive(:color).and_return('white')
      allow(white_pawn).to receive(:fen_representation).and_return('P')
    end

    context 'when the move puts in check own king' do
      it 'raises IllegalMoveError' do
        white_player = Player.new('white')
        black_player = Player.new('black')
        test_board = Board.new
        test_board.add_piece(King.new('white'), 'a1')
        test_board.add_piece(Pawn.new('white'), 'b2')
        test_board.add_piece(Bishop.new('black'), 'h8')
        move = NormalMove.new('b2', 'b3', test_board)
        test_chess = Chess.new(test_board, white_player, black_player)

        expect { test_chess.add_move(move) }.to raise_error(IllegalMoveError)
      end
    end
  end

  describe '#switch_turn' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { instance_double('Player') }
    let(:black_player) { instance_double('Player') }
    let(:board) { instance_double('Board') }

    context 'when it is whites turn' do
      it 'switches to blacks turn' do
        allow(white_player).to receive(:color).and_return('white')
        chess.switch_turn
        expect(chess.turn).to eql(black_player)
      end
    end

    context 'when it is blacks turn' do
      it 'switches to whites turn' do
        allow(white_player).to receive(:color).and_return('white')
        allow(black_player).to receive(:color).and_return('black')
        chess.switch_turn
        chess.switch_turn
        expect(chess.turn).to eql(white_player)
      end
    end
  end

  describe '#serialize' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { instance_double('Player') }
    let(:black_player) { instance_double('Player') }
    let(:board) { instance_double('Board') }

    context 'when serializing an empty game' do
      it 'saves to a YAML file' do
        expect(chess.serialize).to be_instance_of(String)
      end
    end
  end

  describe '#unserialize' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { Board.new }

    context 'when unserialize an empty game' do
      it 'returns a Chess object' do
        expect(Chess.unserialize(chess.serialize)).to be_instance_of(Chess)
      end
    end
  end

  describe '#checkmate?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { Board.new }

    context 'when black is in checkmate' do
      it 'returns true' do
        board.add_piece(King.new('black'), 'a1')
        board.add_piece(Rook.new('white'), 'h2')
        board.add_piece(Rook.new('white'), 'h1')
        chess.switch_turn

        expect(chess.turn).to eq(black_player)
        expect(chess.checkmate?(board, 'black')).to be_truthy
      end
    end

    context 'when black is not in checkmate' do
      it 'returns false' do
        board.add_piece(King.new('black'), 'a1')
        board.add_piece(Rook.new('white'), 'h1')
        chess.switch_turn

        expect(chess.turn).to eq(black_player)
        expect(chess.checkmate?(board, 'black')).to be_falsy
      end
    end

    context 'when a piece move can avoid the checkmate' do
      it 'returns false' do
        board.add_piece(King.new('black'), 'a1')
        board.add_piece(Rook.new('white'), 'h2')
        board.add_piece(Rook.new('white'), 'h1')
        board.add_piece(Rook.new('black'), 'b8')
        chess.switch_turn

        expect(chess.turn).to eq(black_player)
        expect(chess.checkmate?(board, 'black')).to be_falsy
      end
    end
  end

  describe '#stealmate?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { Board.new }

    context 'when white is in steal mate' do
      it 'returns true' do
        board.add_piece(King.new('white'), 'a8')
        board.add_piece(Queen.new('black'), 'b6')

        expect(chess.turn).to eq(white_player)
        expect(chess.stealmate?(board, 'white')).to be_truthy
      end
    end

    context 'when white is in not steal mate' do
      it 'returns true' do
        board.add_piece(King.new('white'), 'h8')
        board.add_piece(Queen.new('black'), 'b6')

        expect(chess.turn).to eq(white_player)
        expect(chess.stealmate?(board, 'white')).to be_falsy
      end
    end

    context 'when a white pawn move can avoid stealmate' do
      it 'returns false' do
        board.add_piece(King.new('white'), 'a8')
        board.add_piece(Queen.new('black'), 'b6')

        board.add_piece(Pawn.new('white'), 'e7')

        expect(chess.turn).to eq(white_player)
        expect(chess.stealmate?(board, 'white')).to be_falsy
      end
    end
  end

  # Tests for MoveCreator module/mixin
  describe '#promotion?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { instance_double('Board') }
    let(:pawn) { instance_double('Pawn') }

    context 'when a pawn is going to promotion in next move' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('e7').and_return(pawn)
        allow(pawn).to receive(:color).and_return('white')
        allow(pawn).to receive(:is_a?).and_return(Pawn)
        expect(chess.promotion?('e7', 'e8', board)).to be_truthy
      end
    end

    context 'when a black pawn is not going to promotion in next move' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('e3').and_return(pawn)
        allow(pawn).to receive(:color).and_return('black')
        allow(pawn).to receive(:is_a?).and_return(Pawn)
        expect(chess.promotion?('e3', 'e2', board)).to be_falsy
      end
    end
  end

  describe '#capture?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { instance_double('Board') }
    let(:pawn) { instance_double('Pawn') }
    let(:rook) { instance_double('Rook') }

    context 'when is a capture move' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('a5').and_return(pawn)
        allow(board).to receive(:get_piece_at).with('a2').and_return(rook)
        allow(pawn).to receive(:color).and_return('white')
        allow(rook).to receive(:color).and_return('black')
        expect(chess.capture?('a2', 'a5', board)).to be_truthy
      end
    end

    context 'when is not capture move' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('a5').and_return(nil)
        allow(board).to receive(:get_piece_at).with('a2').and_return(rook)
        allow(pawn).to receive(:color).and_return('white')
        allow(rook).to receive(:color).and_return('black')
        expect(chess.capture?('a2', 'a5', board)).to be_falsy
      end
    end
  end

  context '#first_pawn_move?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { instance_double('Board') }
    let(:pawn) { instance_double('Pawn') }

    context 'when its a first pawn move for white' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('d2').and_return(pawn)
        allow(board).to receive(:calculate_distance_vector).with('d2', 'd4').and_return([2, 0])
        allow(pawn).to receive(:is_a?).and_return(Pawn)

        expect(chess.first_pawn_move?('d2', 'd4', board)).to be_truthy
      end
    end
  end

  context '#pawn_capture??' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { instance_double('Board') }
    let(:pawn) { instance_double('Pawn') }
    let(:bishop) { instance_double('Bishop') }

    context 'when its a pawn capture' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('d2').and_return(pawn)
        allow(board).to receive(:get_piece_at).with('e3').and_return(bishop)
        allow(board).to receive(:calculate_distance_vector).with('d2', 'e3').and_return([1, 1])
        allow(pawn).to receive(:is_a?).and_return(Pawn)

        expect(chess.pawn_capture?('d2', 'e3', board)).to be_truthy
      end
    end

    context 'when its a not a pawn capture' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('d2').and_return(pawn)
        allow(board).to receive(:get_piece_at).with('d3').and_return(nil)
        allow(board).to receive(:calculate_distance_vector).with('d2', 'e3').and_return([1, 1])
        allow(pawn).to receive(:is_a?).and_return(Pawn)

        expect(chess.pawn_capture?('d2', 'd3', board)).to be_falsy
      end
    end
  end

  context '#en_passant?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { instance_double('Board') }
    let(:pawn) { instance_double('Pawn') }
    let(:first_pawn_move) { instance_double('FirstPawnMove') }
    let(:not_first_pawn_move) { instance_double('NormalMove') }

    context 'when its an en passant pawn move' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('d5').and_return(pawn)
        allow(board).to receive(:last_move).and_return(first_pawn_move)
        allow(first_pawn_move).to receive(:is_a?).and_return(FirstPawnMove)
        allow(pawn).to receive(:is_a?).and_return(Pawn)
        allow(pawn).to receive(:color).and_return('white')
        allow(board).to receive(:calculate_distance_vector).with('d5', 'e6').and_return([1, 1])
        expect(chess.en_passant?('d5', 'e6', board)).to be_truthy
      end
    end

    context 'when its not an en passant pawn move' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('d3').and_return(pawn)
        allow(pawn).to receive(:is_a?).and_return(Pawn)
        allow(pawn).to receive(:color).and_return('black')
        allow(board).to receive(:last_move).and_return(not_first_pawn_move)
        allow(board).to receive(:calculate_distance_vector).with('d3', 'e2').and_return([1, -1])
        expect(chess.en_passant?('d3', 'e2', board)).to be_falsy
      end
    end

    context 'when its an en passant pawn move for black' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('d4').and_return(pawn)
        allow(pawn).to receive(:color).and_return('black')
        allow(pawn).to receive(:is_a?).and_return(Pawn)
        allow(board).to receive(:last_move).and_return(first_pawn_move)
        allow(first_pawn_move).to receive(:is_a?).and_return(FirstPawnMove)
        allow(board).to receive(:calculate_distance_vector).with('d4', 'e3').and_return([1, -1])
        expect(chess.en_passant?('d4', 'e3', board)).to be_truthy
      end
    end
  end

  context '#insuficient_material?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { Board.new }
    let(:white_king) { King.new('white') }
    let(:black_king) { King.new('black') }
    let(:black_rook) { Rook.new('black') }

    context 'when there are two kings on the board' do
      it 'returns true' do
        board.add_piece(white_king, 'e1')
        board.add_piece(black_king, 'e8')
        expect(chess.insuficient_material?(board)).to be_truthy
      end
    end

    context 'when there are two kings and a rook on the board' do
      it 'returns false' do
        board.add_piece(white_king, 'e1')
        board.add_piece(black_king, 'e8')
        board.add_piece(black_rook, 'h8')
        expect(chess.insuficient_material?(board)).to be_falsy
      end
    end

    context 'when there are two kings and a white knight and a black bishop' do
      it 'returns true' do
        board.add_piece(white_king, 'e1')
        board.add_piece(black_king, 'e8')
        board.add_piece(Knight.new('black'), 'h8')
        board.add_piece(Bishop.new('white'), 'a1')
        expect(chess.insuficient_material?(board)).to be_truthy
      end
    end
  end
end
