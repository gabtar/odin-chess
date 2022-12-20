# frozen_string_literal: true

# Replaces the current window with a new menu
# @attr menu [MenuChess] the actual menu chess object
# @attr submenu [Array] the array of command menu objects to be replaced in the menu
# @attr name [String] the name that will be rendered in the menu
# @attr window [Window] the Curses Window object that renders the menu
# @attr back_menu [Boolean] if we want to add an option to create a back button on the menu
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
