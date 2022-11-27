# Wrapper for the chess game object for handling games in the TUI
class ChessGame
  attr_accessor :current_game

  include GameConfigurator

  def initialize
    @current_game = create_new_game
  end

  # Creates a new chess game between 2 players
  def new_game
    @current_game = create_new_game
  end

  # Loads a game from the specified yaml string
  # @attr file [String] the yaml string representing the Chess object previously serialized
  def load_game(file)
    @current_game = Chess.unserialize(file)
  end

  # Make a move +from+ origin square +to+ destination sqaure in the current game instance
  # @attr from [String] the starting square coordinate
  # @attr to [String] the ending square coordinate
  def add_move(from, to)
    @current_game.add_move(from, to)
  end

  # Serializes the current game instance into a yaml string
  def serialize
    @current_game.serialize
  end
end
