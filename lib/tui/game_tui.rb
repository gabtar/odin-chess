# frozen_string_literal: true

require 'curses'

require_relative '../helpers/game_configurator'
require_relative '../helpers/game_reporter'
require_relative '../helpers/chess_game'

require_relative './menu/command/load_command'
require_relative './menu/command/enter_move_command'
require_relative './menu/command/new_game_command'
require_relative './menu/command/sub_menu_command'
require_relative './menu/command/exit_command'
require_relative './menu/command/save_command'
require_relative './menu/menu_chess'

# Game Terminal UI using Curses library
class GameTUI
  include Curses
  include GameReporter

  WELCOME_SCREEN = <<~'WELCOME_SCREEN'
                  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⢾⡷⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣈⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⠀⣿⣿⣿⣿⠀⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣇⠸⣿⣿⠇⣸⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀
                  ⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠙⠋⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀
                  ⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⠉⣉⣉⣉⣉⣉⣉⣉⣁⣈⣉⣉⣉⣉⣉⣉⣉⠉⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠀⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⠀⠀⠀⠀⠀⠀
                  ⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
     _____      _               ___    _
    (  _  )    ( ) _           (  _`\ ( )
    | ( ) |   _| |(_)  ___     | ( (_)| |__     __    ___   ___
    | | | | /'_` || |/' _ `\   | |  _ |  _ `\ /'__`\/',__)/',__)
    | (_) |( (_| || || ( ) |   | (_( )| | | |(  ___/\__, \\__, \
    (_____)`\__,_)(_)(_) (_)   (____/'(_) (_)`\____)(____/(____/


                      Press any key to start


  WELCOME_SCREEN

  START_SCREEN = <<~'START_SCREEN'
     _____      _               ___    _
    (  _  )    ( ) _           (  _`\ ( )
    | ( ) |   _| |(_)  ___     | ( (_)| |__     __    ___   ___
    | | | | /'_` || |/' _ `\   | |  _ |  _ `\ /'__`\/',__)/',__)
    | (_) |( (_| || || ( ) |   | (_( )| | | |(  ___/\__, \\__, \
    (_____)`\__,_)(_)(_) (_)   (____/'(_) (_)`\____)(____/(____/

    Select an option in the menu to start a new game or load a saved one.
  START_SCREEN

  def initialize
    @game = ChessGame.new
  end

  # Starts the main game interface
  def start
    init_screen
    begin
      win = Window.new(lines, cols, 0, 0)
      win.keypad = true

      crmode
      draw_multiline_string(WELCOME_SCREEN, win)
      win.getch
      win.clear
      Curses.curs_set(0) # Hide cursor
      Curses.noecho # echo or noecho to display user input
      Curses.cbreak # do not buffer commands until Enter is pressed
      Curses.raw # disable interpretation of keyboard input
      Curses.nonl

      # Board window
      board = win.subwin(lines, cols * 3 / 4, 0, 0)
      board.box('|', '-')

      # Menu window
      menu = win.subwin(lines / 4, cols / 4, 0, cols * 3 / 4)
      menu.box('|', '-')

      # Moves list
      moves = win.subwin(lines * 3 / 4, cols / 4, lines / 4, cols * 3 / 4)
      moves.box('|', '-')

      # Render initial screen
      draw_multiline_string(START_SCREEN, board)
      draw_multiline_string(moves_status([], moves.maxy - 4), moves, false)

      # Build the menu
      menu_class = MenuChess.new(menu)

      ingame_menu_options = [
        EnterMoveCommand.new(@game, menu, menu_class),
        SaveCommand.new(@game, menu),
        ExitCommand.new
      ]

      new_game_menu_options = [
        NewGameCommand.new(menu_class, ingame_menu_options, '2 Players Game', menu, @game, computer_player: false),
        NewGameCommand.new(menu_class, ingame_menu_options, 'Play vs Computer', menu, @game, computer_player: true)
      ]
      switch_new_game_menu_command = SubMenuCommand.new(menu_class, new_game_menu_options, 'New Game', menu,
                                                        back_menu: true)
      switch_in_game_menu_command = SubMenuCommand.new(menu_class, ingame_menu_options, 'In game menu', menu,
                                                       back_menu: true)

      # Get saves entries for the load menu
      saves_path = File.join(File.dirname(__FILE__), '../../saves')
      options = Dir.each_child(saves_path)
      load_menu_options = options.map { |file| LoadCommand.new(file.to_s, @game, switch_in_game_menu_command) }
      switch_load_game_menu_command = SubMenuCommand.new(menu_class, load_menu_options, 'Load Game', menu,
                                                         back_menu: true)

      menu_class.add_option(switch_new_game_menu_command)
      menu_class.add_option(switch_load_game_menu_command)
      menu_class.add_option(ExitCommand.new)

      menu_class.render
      while (ch = win.getch)
        case ch
        when KEY_UP, 'w'
          menu_class.previous
        when KEY_DOWN, 's'
          menu_class.next
        when 13
          menu_class.execute
        end
        menu_class.render

        if @game.current_game.nil?
          draw_multiline_string(START_SCREEN, board)
          draw_multiline_string(moves_status([], moves.maxy - 4), moves, false)
        else
          draw_multiline_string(board_status(@game.current_game), board)
          draw_multiline_string(moves_status(@game.current_game.moves_list, moves.maxy - 4), moves, false)
        end

      end
    ensure
      close_screen
    end
  end

  def draw_multiline_string(string, window, center = true)
    window.clear
    window.box('|', '-')
    height = string.lines.length
    # Gets the max width of a multiline string
    width = string.lines.max { |a, b| a.length <=> b.length }.length

    initial_y = center ? (window.maxy - height) / 2 : 1
    center_x = (window.maxx - width) / 2
    string.lines.map(&:chomp).each do |line|
      window.setpos(initial_y, center_x)
      window.addstr(line)
      initial_y += 1
    end
    window.setpos(initial_y - 1, center_x * 2)
    window.refresh
  end
end
