
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
        play_game
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

  def display_new_game_menu
    puts <<~NEW_GAME_MENU
      ----------------------
        ♔ Odin chess
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

  def play_game
    loop do
      puts @game.board
      play_move
      @game.switch_turn
      break if @game.checkmate?
    end
  end

  def play_move
    loop do
      puts "#{@game.turn} to move"
      puts 'Enter starting square: '
      from = gets.chomp
      puts 'Enter destination square: '
      to = gets.chomp
      begin
        @game.add_move(from, to)
        break
      rescue => e
        puts e.message
      end
    end
  end

  def options_menu
    puts <<~OPTIONS_MENU
      ----------------------
        ♔ Odin chess - Ingame menu
      ----------------------
      1 - Play move (#{@game.turn} turn)
      2 - Save game
      3 - Resign(exit)
      ----------------------
    OPTIONS_MENU
  end

  def select_option
    selected = ''
    loop do
      puts 'Enter selection: '
      selected = gets.chomp
      break if %w[1 2 3].include?(selected)

      puts 'Invalid option'
    end
    case selected
    when '1'
      play_move
    when '2'
      save_game
    when '3'
      exit!
    end
  end

  def save_game
    puts 'Enter filename: '
    filename = gets.chomp
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.expand_path("./saves/#{filename}"), 'w') { |file| file.puts @game.serialize }
  end
end
