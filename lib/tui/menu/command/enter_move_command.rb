# frozen_string_literal: true

require_relative '../../../chess/moves/move_creator'
# Command to enter a move to the game
#
# @attr game [Chess] the current Chess game object
# @attr window [Window] a Curses.Window object where the command will be rendered
class EnterMoveCommand
  include MoveCreator

  attr_reader :name

  def initialize(game, window, global_menu)
    @game = game
    @name = 'Enter move'
    @global_menu = global_menu
    @window = window
  end

  # Executes the command
  def execute
    from = input_move('From square: ')
    to = input_move('To square: ')
    Curses.curs_set(0) # Hide cursor

    begin
      piece = nil
      if promotion?(from, to, @game.current_game.board)
        piece = input_move('Promote to(Q/R/N/B): ') until %w[Q R N B].include?(piece)
        case piece
        when 'Q'
          piece = Queen.new(@game.current_game.turn.color)
        when 'R'
          piece = Rook.new(@game.current_game.turn.color)
        when 'B'
          piece = Bishop.new(@game.current_game.turn.color)
        when 'N'
          piece = Knight.new(@game.current_game.turn.color)
        end
      end
      move = create_move(from, to, @game.current_game.board, piece)

      @game.add_move(move)

      if @game.finished?
        display_message(" Game finished, #{@game.result} ")
        @window.refresh
        sleep(1)
        # Execute back command
        @global_menu.options[3].execute
        return
      end

      # If the opponent is a ComputerPlayer, perform the computer move
      loop do
        @game.add_move(@game.current_game.turn.play_move) if @game.current_game.turn.is_a?(ComputerPlayer)
        break
      rescue IllegalMoveError
        next
      end
    rescue StandardError => e
      display_message(e.message)
      @window.refresh
      sleep(1)
    end
  end

  # Displays a message in the window
  # @attr message [String] the message to be displayed to the user
  def display_message(message)
    @window.clear
    @window.box('|', '-')
    @window.refresh
    @window.setpos(@window.cury + 1, @window.curx + 1)
    @window.addstr(message)
  end

  # Gets a coordinate input from user
  # @attr message [String] the message to be displayed to the user
  def input_move(message)
    display_message(message)
    Curses.curs_set(1) # Show cursor

    @window.keypad(false)
    input = ''
    while (ch = @window.getch)
      case ch
      when 13 # Return key code
        break
      when 127 # Backspace key code
        unless input.empty?
          @window.setpos(@window.cury, @window.curx - 1)
          @window.addstr(' ')
          @window.setpos(@window.cury, @window.curx - 1)
          input = input.slice(0, input.length - 1)
        end
      else
        input += ch.to_s
        @window.addstr(ch.to_s)
      end
    end
    input
  end
end
