# frozen_string_literal: true

# Command to save the game
#
# @attr game [Chess] the current Chess game object to be serialized
class SaveCommand
  attr_reader :name

  def initialize(game, window)
    @game = game
    @name = 'Save Game'
    @window = window
  end

  # Executes the command
  def execute
    filename = input_move('Enter filename: ')
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.expand_path("./saves/#{filename}.yml"), 'w') { |file| file.puts @game.serialize }
    Curses.curs_set(0) # Show cursor
    display_message('Game saved!')
    @window.refresh
    sleep(1)
  end

  # Gets input from user
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

  # Displays a message in the window
  # @attr message [String] the message to be displayed to the user
  def display_message(message)
    @window.clear
    @window.box('|', '-')
    @window.refresh
    @window.setpos(@window.cury + 1, @window.curx + 1)
    @window.addstr(message)
  end
end
