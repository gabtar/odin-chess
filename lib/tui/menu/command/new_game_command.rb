# frozen_string_literal: true

require_relative './sub_menu_command'
require_relative '../../../helpers/game_configurator'

# Creates an empty game and loads the ingame menu
# @attr name [MenuChess] the actual menu chess object
# @attr name [MenuChess] the new menu that will be displayed after
# @attr name [String] the name that will be rendered in the menu
class NewGameCommand < SubMenuCommand
  include GameConfigurator

  attr_reader :name

  def initialize(menu, submenu, name, window, game, computer_player: false, back_menu: false)
    super(menu, submenu, name, window, back_menu: back_menu)
    @game = game
    @computer_player = computer_player
  end

  # Creates the game and swites to submenu(ingame menu)
  def execute
    @game.new_game(@computer_player)
    super
  end
end
