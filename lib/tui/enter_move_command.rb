# frozen_string_literal: true

# Command to enter a move to the game
#
# @attr game [Chess] the current Chess game object
# @attr window [Window] a Curses.Window object where the command will be rendered
class EnterMoveCommand
  attr_reader :name

  def initialize(game, window)
    @game = game
    @name = 'Enter move'
    @window = window
  end

  # Executes the command
  def execute
    from = input_move('From square: ')
    to = input_move('To square: ')
    Curses.curs_set(0) # Hide cursor

    begin
      @game.add_move(from, to)
    rescue => e
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
