# frozen_string_literal: true

require_relative '../lib/game'

RSpec.describe Game do
  let(:new_game_menu) do
    <<~NEW_GAME_MENU
      ----------------------
        ♔ Odin chess
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
      it 'creates a new game' do
        expect(game).to receive(:puts).with(new_game_menu).once
        allow(game).to receive(:play_game)
        expect(game).to receive(:create_new_game).once
        allow(game).to receive(:gets).and_return('1')
        game.start_game
      end
    end
  end

  describe '#play_move' do
    subject(:game) { described_class.new }
    context 'when playing a game' do
      it 'ask current player for a move and updates the board with the move' do
        expect(game).to receive(:puts).with('white to move').once
        expect(game).to receive(:puts).with('Enter starting square: ').once
        allow(game).to receive(:gets).and_return('a2', 'a4')
        expect(game).to receive(:puts).with('Enter destination square: ').once
        game.new_game
        game.play_move
      end
    end

    context 'when playing a game' do
      it 'loops once if the move is invalid' do
        expect(game).to receive(:puts).with('white to move').twice
        expect(game).to receive(:puts).with('Enter starting square: ').twice
        allow(game).to receive(:gets).and_return('f5', 'f6', 'a2', 'a4')
        expect(game).to receive(:puts).with('Enter destination square: ').twice
        expect(game).to receive(:puts).with('Invalid piece').once
        game.new_game
        game.play_move
      end
    end
  end

  describe '#play_game' do
    subject(:game) { described_class.new }
    context 'when a new game is started' do
      it 'loops asking for move entry until a player wins' do
        # Suppress board puts output when executing rspec
        allow($stdout).to receive(:write)
        # Fool's mate moves(shortest checkmate move sequence)
        allow(game).to receive(:gets).and_return('f2', 'f3', 'e7', 'e5', 'g2', 'g4', 'd8', 'h4')
        game.new_game
        game.play_game
      end
    end
  end

  describe '#options_menu' do
    subject(:game) { described_class.new }
    let(:options_menu) do
      <<~OPTIONS_MENU
        ----------------------
          ♔ Odin chess - Ingame menu
        ----------------------
        1 - Play move (white turn)
        2 - Save game
        3 - Resign(exit)
        ----------------------
      OPTIONS_MENU
    end
    context 'when the options menu is called' do
      it 'display the current options' do
        expect(game).to receive(:puts).with(options_menu)
        game.new_game
        game.options_menu
      end
    end
  end

  describe '#select_option' do
    subject(:game) { described_class.new }
    context 'when play move is selected' do
      it 'ask the current player to enter a move' do
        allow(game).to receive(:gets).and_return('1')
        expect(game).to receive(:play_move).once
        game.select_option
      end
    end

    context 'when save game is selected' do
      it 'saves the game to a file and ends' do
        allow(game).to receive(:gets).and_return('2')
        expect(game).to receive(:save_game).once
        game.select_option
      end
    end

    context 'when resign is selected' do
      it 'exits the game' do
        allow(game).to receive(:gets).and_return('3')
        expect(game).to receive(:exit!).once
        game.select_option
      end
    end

    context 'when an invalid option is selected' do
      it 'display invalid option and puts the menu again' do
        allow(game).to receive(:gets).and_return('9', '1')
        expect(game).to receive(:puts).with('Enter selection: ').twice
        expect(game).to receive(:puts).with('Invalid option').once
        expect(game).to receive(:play_move).once
        game.select_option
      end
    end
  end

  context '#save_game' do
    subject(:game) { described_class.new }
    it 'saves the game to a yml file' do
      allow(game).to receive(:gets).and_return('game1')
      expect(game).to receive(:puts).with('Enter filename: ').once
      expect(File).to receive(:open).once
      game.new_game
      game.save_game
    end
  end
end
