# frozen_string_literal: true

# Command to save the game
#
# @attr game [Chess] the current Chess game object to be serialized
class SaveCommand
  attr_reader :name

  def initialize(game)
    @game = game
    @name = 'Save Game'
  end

  # Executes the command
  def execute
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.expand_path("./saves/game.yml"), 'w') { |file| file.puts @game.serialize }
  end
end
