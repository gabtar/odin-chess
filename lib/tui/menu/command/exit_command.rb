# frozen_string_literal: true

# Command to exit the game
class ExitCommand
  attr_reader :name

  def initialize
    @name = 'Exit game'
  end

  # Executes the command
  def execute
    Curses.close_screen
    exit!
  end
end
