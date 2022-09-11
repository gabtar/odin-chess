# frozen_string_literal: true

# Replaces the current window with a new menu
# @attr name [MenuChess] the actual menu chess object
# @attr name [MenuChess] the new menu that will be displayed after
# @attr name [String] the name that will be rendered in the menu
class SubMenuCommand
  attr_reader :name

  def initialize(menu, submenu, name, window)
    @menu = menu
    @submenu = submenu
    @name = name
    @window = window
  end

  def execute
    @menu.options = @submenu.options
    @menu.max_items = @submenu.options.length - 1
    @menu.render
  end
end
