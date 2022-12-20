# frozen_string_literal: true

require_relative './player'
require_relative './moves/move_creator'

# A computer chess player for the game
#
# @attr colour [String] the colour army of the player
class ComputerPlayer < Player
  include MoveCreator

  def initialize(color, board)
    super(color)
    @board = board
  end

  # Returns a random move
  def play_move
    # TODO: check if its stealmate or something?
    loop do
      from = random_rank + random_file
      to = random_rank + random_file
      begin
        move = create_move(from, to, @board)
        move.validate
        return move
      rescue IllegalMoveError, InvalidCoordinateError
        # its invalid
        next
      end
      break
    end
  end

  private

  def random_rank
    ('a'..'h').to_a.sample
  end

  def random_file
    ('1'..'8').to_a.sample
  end
end
