# frozen_string_literal: true

require_relative '../lib/chess/player'

RSpec.describe Player do
  describe '#colour' do
    subject(:player) { described_class.new('white') }
    context 'when its playing white' do
      it 'returns white' do
        expect(player.color).to eql('white')
      end
    end
  end
end
