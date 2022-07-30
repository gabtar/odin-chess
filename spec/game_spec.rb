# frozen_string_literal: true

require_relative '../lib/game'

RSpec.describe Game do
  describe '#start_game' do
    subject(:game) { described_class.new }
    context 'when there is a new game' do
      it 'starts the main loop until the game is finished' do
        expect(game).to receive(:puts).with('Game started!').once
        game.start_game
      end
    end
  end
end
