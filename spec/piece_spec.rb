# frozen_string_literal: true

require_relative '../lib/chess/pieces/piece'
require_relative '../lib/chess/pieces/pawn'

RSpec.describe Piece do
  describe '#same_color?' do
    subject(:black_piece) { described_class.new('black', '♟') }
    let(:white_piece) { Piece.new('white', '♙') }
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

  describe '#to_s' do
    let(:white_pawn) { Piece.new('white', '♙') }
    let(:black_pawn) { Piece.new('black', '♟') }

    context 'when its a white pawn' do
      it 'returns the white pawn symbol (♙)' do
        expect(white_pawn.to_s).to eql('♙')
      end
    end

    context 'when its a black pawn' do
      it 'returns the white pawn symbol (♟)' do
        expect(black_pawn.to_s).to eql('♟')
      end
    end
  end
end
