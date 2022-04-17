# frozen_string_literal: true

require_relative '../lib/chess/pieces/piece'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Piece do
  describe '#same_color?' do
    subject(:black_piece) { described_class.new('black') }
    let(:white_piece) { Piece.new('white') }
    let(:black_pawn) { Pawn.new('black') }

    context 'when comparing with same color piece' do
      it 'returns true' do
        expect(black_piece.same_color?(black_pawn)).to be_truthy
      end
    end

    context 'when comparing with opponent piece color' do
      it 'returns false' do
        expect(black_piece.same_color?(white_piece)).to be_falsy
      end
    end
  end
end
