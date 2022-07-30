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
      it 'it adds the move to the game' do
        allow(board).to receive(:get_piece_at).with('a1').and_return(white_pawn)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'a1', 'b2').and_return(true)
        allow(board).to receive(:add_piece).with(any_args)
        allow(board).to receive(:in_check?).with(any_args)
        chess.add_move('a1', 'b2')
        expect(chess.moves_list).to have_attributes(size: (be > 0))
      end
    end

    context 'when it is an invalid move' do
      it 'raises IllegalMoveError' do
        allow(board).to receive(:get_piece_at).with('a1').and_return(white_pawn)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'a1', 'b5').and_return(false)
        expect { chess.add_move('a1', 'b5') }.to raise_error(IllegalMoveError)
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

    context 'when the move is invalid' do
      it 'raises IllegalMoveError' do
        allow(board).to receive(:get_piece_at).with('a1').and_return(white_pawn)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'a1', 'b5').and_return(false)
        expect { chess.validate_move('a1', 'b5') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when its black s turn and moves a white piece' do
      it 'raises IllegalMoveError' do
        chess.switch_turn
        allow(board).to receive(:get_piece_at).with('a1').and_return(white_pawn)
        allow(white_pawn).to receive(:can_move_to?).with(board, 'a1', 'b5').and_return(false)
        expect { chess.validate_move('a1', 'a3') }.to raise_error(IllegalMoveError)
      end
    end

    context 'when the move puts in check own king' do
      it 'raises IllegalMoveError' do
        white_player = Player.new('white')
        black_player = Player.new('black')
        test_board = Board.new
        test_board.add_piece(King.new('white'), 'a1')
        test_board.add_piece(Pawn.new('white'), 'b2')
        test_board.add_piece(Bishop.new('black'), 'h8')
        test_chess = Chess.new(test_board, white_player, black_player)

        expect { test_chess.add_move('b2', 'b4') }.to raise_error(IllegalMoveError)
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
end
