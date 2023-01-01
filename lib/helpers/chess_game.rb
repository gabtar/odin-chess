# frozen_string_literal: true

# Wrapper for the chess object for handling games in the TUI
class ChessGame
  attr_reader :result, :current_game

  include GameConfigurator

  def initialize
    @current_game = nil
    @result = nil
  end

  # Creates a new chess game between 2 players
  # @attr play_vs_computer [Boolean] allows 1 ramdom player to be a computer player
  def new_game(play_vs_computer)
    @result = nil
    @current_game = create_new_game(computer_player: play_vs_computer)
  end

  # Loads a game from the specified yaml string
  # @attr file [String] the yaml string representing the Chess object previously serialized
  def load_game(file)
    @current_game = Chess.unserialize(file)
  end

  # Make a move +from+ origin square +to+ destination sqaure in the current game instance
  # @attr move [Move] the move we want to add to the current game
  def add_move(move)
    opponent = @current_game.turn.color == 'white' ? 'black' : 'white'
    @current_game.add_move(move)

    check_result(opponent)
  end

  # Serializes the current game instance into a yaml string
  def serialize
    @current_game.serialize
  end

  # Returns if the game has ended
  def finished?
    !@result.nil?
  end

  private

  def check_result(opponent)
    # Store in a result parameter
    winner = opponent == 'white' ? '0 - 1' : '1 - 0'
    @result = winner if @current_game.checkmate?(@current_game.board, opponent)
    @result = '½ - ½ by stealmate' if @current_game.stealmate?(@current_game.board, opponent)
    @result = '½ - ½ by repetition' if @current_game.threefold_repetition?
    @result = '½ - ½ by insuficient material' if @current_game.insuficient_material?(@current_game.board)

    @current_game.result = @result
  end
end
