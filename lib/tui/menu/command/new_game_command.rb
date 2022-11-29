# frozen_string_literal: true

# Creates an empty game and loads the ingame menu
# @attr name [MenuChess] the actual menu chess object
# @attr name [MenuChess] the new menu that will be displayed after
# @attr name [String] the name that will be rendered in the menu
class NewGameCommand
  attr_reader :name

  def initialize(menu, submenu, name)
    @menu = menu
    @submenu = submenu
    @name = name
  end

  # Switches to a new game menu
  def execute
    @menu.options = @submenu.options
    @menu.max_items = @submenu.options.length - 1
    @menu.render
  end
end
