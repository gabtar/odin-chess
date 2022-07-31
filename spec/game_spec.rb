# frozen_string_literal: true

require_relative '../lib/game'

RSpec.describe Game do
  let(:new_game_menu) do
    <<~NEW_GAME_MENU
      ----------------------
        Odin chess
      ----------------------
      1 - Start a new game (2 players)
      2 - Restore a saved game
      3 - Exit
      ----------------------
    NEW_GAME_MENU
  end

  describe '#start_game' do
    subject(:game) { described_class.new }

    context 'when starts the game and the user input exit' do
      it 'displays the menu and exits the game' do
        allow(game).to receive(:gets).and_return('3')
        expect(game).to receive(:puts).with(new_game_menu).once
        game.start_game
      end
    end

    context 'when starts the game and the user inputs an invalid option' do
      it 'puts a message and displays the menu again' do
        allow(game).to receive(:gets).and_return('93', '3')
        expect(game).to receive(:puts).with(new_game_menu).twice
        expect(game).to receive(:puts).with('Invalid Option').once
        game.start_game
      end
    end
  end

  describe '#display_new_game' do
    subject(:game) { described_class.new }
    context 'when a game starts' do
      it 'displays the menu' do
        expect(game).to receive(:puts).with(new_game_menu).once
        game.display_new_game_menu
      end
    end
  end

  describe '#new_game' do
    subject(:game) { described_class.new }
    context 'when a new game is started' do
      it 'starts a new game until finish' do
        expect(game).to receive(:puts).with(new_game_menu).once
        expect(game).to receive(:create_new_game).once
        allow(game).to receive(:gets).and_return('1')
        game.start_game
      end
    end
  end

  describe '#play_game' do
    subject(:game) { described_class.new }
    context 'when the black player gives checkmate' do
      it 'finish the game' do
        # TODO
        raise "Not implemented"
      end
    end
  end
end
