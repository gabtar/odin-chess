# frozen_string_literal: true

require 'curses'

require_relative './tui/menu_chess'
require_relative './tui/exit_command'
require_relative './tui/save_command'
require_relative './tui/enter_move_command'
require_relative './game_configurator'

# Game Terminal UI using Curses library
class GameTUI
  include Curses

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

  def initialize
    @game = Game.new
    # I should have a curses helper for building the user interface
  end

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
      draw_multiline_string(@game.current_game.board.to_s, board)
      draw_moves_list(@game.current_game.moves_list, moves)

      new_game_menu = MenuChess.new(menu)
      new_game_menu.add_option(EnterMoveCommand.new(@game, menu))
      new_game_menu.add_option(SaveCommand.new(@game))
      new_game_menu.add_option(ExitCommand.new)

      menu_class = MenuChess.new(menu)
      switch_menu_command = SubMenuCommand.new(menu_class, new_game_menu, 'New game')
      menu_class.add_option(switch_menu_command)
      menu_class.add_option(LoadGameCommand.new(menu_class, 'Load a game', @game, @menu, switch_menu_command))
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
        when 'x'
          Curses.close_screen
          exit!
        end
        # TODO: clear/Redraw windows
        # TODO draw moves list on panel
        # TODO check for checkmate on every turn
        menu_class.render
        draw_multiline_string(@game.current_game.board.to_s, board)
        draw_moves_list(@game.current_game.moves_list, moves)
      end

      refresh
    ensure
      close_screen
    end
  end

  def draw_multiline_string(string, window)
    height = string.lines.length
    # Gets the max width of a multiline string
    width = string.lines.max { |a, b| a.length <=> b.length }.length

    initial_y = (window.maxy - height) / 2
    center_x = (window.maxx - width) / 2
    string.lines.map(&:chomp).each do |line|
      window.setpos(initial_y, center_x)
      window.addstr(line)
      initial_y += 1
    end
    window.setpos(initial_y - 1, center_x * 2)
    window.refresh
  end

  def draw_moves_list(moves_list, window)
    title = 'Moves list'
    window.setpos(1, (window.maxx - title.length) / 2)
    window.addstr(title)
    window.setpos(3, 1)
    move_number = 1
    moves_list.each_slice(2) do |move|
      window.addstr("#{move_number}. #{move}")
      window.setpos(window.cury + 1, 1)
      move_number += 1
    end

    window.refresh
  end
end
