# frozen_string_literal: true

# A class to load chess saved games under the TUI
# @attr name [String] the name that will be rendered in the menu
# @attr name [Game] the current game instance
# @attr name [SubMenuCommand] the new menu that will be displayed after
#   loading the game
class LoadCommand
  attr_reader :name

  def initialize(name, game, switch_menu_command)
    @name = name
    @game = game
    @switch_menu_command = switch_menu_command
  end

  # Loads a saved game of chess with the name of the +name+ attribute
  def execute
    saves_path = File.join(File.dirname(__FILE__), '../../../../saves')
    file = File.readlines("#{saves_path}/#{name}").join
    @game.load_game(file)
    # Re swtiches the menus again
    # If no games found
    @switch_menu_command.execute
  end
end
