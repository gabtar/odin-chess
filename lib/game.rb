# frozen_string_literal: true

require_relative './game_configurator'

# Main class for playing a chess game
class Game
  include GameConfigurator

  def initialize; end

  # Starts a new game or load a saved game of chess
  def start_game
    loop do
      display_new_game_menu
      selected_option = gets.chomp
      case selected_option
      when '1'
        # TODO: start a new game
        new_game
        break
      when '2'
        # TODO: load a saved game
      when '3'
        break
      else
        puts 'Invalid Option'
      end
      # TODO: play game until some player wins
    end
  end

  # Displays the game menu
  def display_new_game_menu
    puts <<~NEW_GAME_MENU
      ----------------------
        Odin chess
      ----------------------
      1 - Start a new game (2 players)
      2 - Restore a saved game
      3 - Exit
      ----------------------
    NEW_GAME_MENU
  end

  def new_game
    @game = create_new_game
  end
end
