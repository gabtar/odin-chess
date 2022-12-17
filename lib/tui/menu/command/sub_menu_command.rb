# frozen_string_literal: true

# Replaces the current window with a new menu
# @attr name [MenuChess] the actual menu chess object
# @attr name [MenuChess] the new menu that will be displayed after
# @attr name [String] the name that will be rendered in the menu
class SubMenuCommand
  attr_reader :name

  def initialize(menu, submenu, name, window, back_menu: false)
    @menu = menu
    @submenu = submenu
    @original_options = menu.options
    @name = name
    @window = window
    # Back command
    @submenu.append(SubMenuCommand.new(@menu, @original_options, 'Back', @window)) if back_menu
  end

  def execute
    @menu.active_index = 0
    @menu.options = @submenu
    @menu.max_items = @submenu.length - 1
    @menu.render
  end
end
