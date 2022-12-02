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
    let(:board) { instance_double('Board') }
    let(:white_pawn) { instance_double('Pawn') }

    before :each do
      allow(white_pawn).to receive(:color).and_return('white')
    end

    context 'when it is a valid move' do
      let(:move) { NormalMove.new('a1', 'b2', board) }

      it 'it adds the move to the game' do
        allow(board).to receive(:get_piece_at).with('a1').and_return(white_pawn)
        allow(board).to receive(:get_piece_at).exactly(3).times.with('b2').and_return(nil)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'a1', 'b2').and_return(true)
        allow(board).to receive(:add_piece).with(any_args)
        allow(board).to receive(:in_check?).with(any_args)
        chess.add_move(move)
        expect(chess.moves_list).to have_attributes(size: (be > 0))
      end
    end

    context 'when it is an invalid move' do
      let(:move) { NormalMove.new('a1', 'b5', board) }

      it 'raises IllegalMoveError' do
        allow(board).to receive(:get_piece_at).with('a1').and_return(white_pawn)
        allow(board).to receive(:get_piece_at).with('b5').and_return(nil)
        allow(board).to receive(:add_piece).with(any_args)
        allow(board).to receive(:in_check?).with(any_args).and_return(false)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'a1', 'b5').and_return(false)
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
    end

    context 'when the move puts in check own king' do
      it 'raises IllegalMoveError' do
        white_player = Player.new('white')
        black_player = Player.new('black')
        test_board = Board.new
        move = NormalMove.new('a1', 'b2', test_board)
        test_board.add_piece(King.new('white'), 'a1')
        test_board.add_piece(Pawn.new('white'), 'b2')
        test_board.add_piece(Bishop.new('black'), 'h8')
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
        chess.switch_turn
        expect(chess.turn).to eql('black')
      end
    end

    context 'when it is blacks turn' do
      it 'switches to whites turn' do
        chess.switch_turn
        chess.switch_turn
        expect(chess.turn).to eql('white')
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

        expect(chess.turn).to eq('black')
        expect(chess.checkmate?).to be_truthy
      end
    end

    context 'when black is not in checkmate' do
      it 'returns false' do
        board.add_piece(King.new('black'), 'a1')
        board.add_piece(Rook.new('white'), 'h1')
        chess.switch_turn

        expect(chess.turn).to eq('black')
        expect(chess.checkmate?).to be_falsy
      end
    end

    context 'when a piece move can avoid the checkmate' do
      it 'returns false' do
        board.add_piece(King.new('black'), 'a1')
        board.add_piece(Rook.new('white'), 'h2')
        board.add_piece(Rook.new('white'), 'h1')
        board.add_piece(Rook.new('black'), 'b8')
        chess.switch_turn

        expect(chess.turn).to eq('black')
        expect(chess.checkmate?).to be_falsy
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

  context '#en_passant?' do
    subject(:chess) { described_class.new(board, white_player, black_player) }
    let(:white_player) { Player.new('white') }
    let(:black_player) { Player.new('black') }
    let(:board) { instance_double('Board') }
    let(:pawn) { instance_double('Pawn') }

    context 'when its an en passant pawn move' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('d5').and_return(pawn)
        allow(pawn).to receive(:color).and_return('white')
        allow(board).to receive(:calculate_distance_vector).with('d5', 'e6').and_return([1, 1])
        expect(chess.en_passant?('d5', 'e6', board)).to be_truthy
      end
    end

    context 'when its not an en passant pawn move' do
      it 'returns false' do
        allow(board).to receive(:get_piece_at).with('d3').and_return(pawn)
        allow(pawn).to receive(:color).and_return('black')
        allow(board).to receive(:calculate_distance_vector).with('d3', 'e2').and_return([1, -1])
        expect(chess.en_passant?('d3', 'e2', board)).to be_falsy
      end
    end

    context 'when its an en passant pawn move for black' do
      it 'returns true' do
        allow(board).to receive(:get_piece_at).with('d4').and_return(pawn)
        allow(pawn).to receive(:color).and_return('black')
        allow(board).to receive(:calculate_distance_vector).with('d4', 'e3').and_return([1, -1])
        expect(chess.en_passant?('d4', 'e3', board)).to be_truthy
      end
    end
  end
end
