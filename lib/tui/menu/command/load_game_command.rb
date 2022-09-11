# frozen_string_literal: true

# Loads a saved game and loads the ingame menu
class LoadGameCommand
  attr_reader :name

  def initialize(menu, name, game, window, switch_menu_command)
    @game = game
    @window = window
    @menu = menu
    @name = name
    @switch_menu_command = switch_menu_command
  end

  def execute
    saves_path = File.join(File.dirname(__FILE__), '../../../../saves')
    options = Dir.each_child(saves_path)

    games_list_menu = MenuChess.new(
      @window,
      options.map { |file| LoadCommand.new(file.to_s, @game, @switch_menu_command) }
    )
    games_list_menu.add_option(ExitCommand.new)

    @menu.options = games_list_menu.options
    @menu.max_items = games_list_menu.options.length - 1
    @window.clear
    @window.box('|', '-')
    @window.refresh
    @menu.render
  end
end
