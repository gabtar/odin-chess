# frozen_string_literal: true

# Error for illegal moves, thats any move that does not follow the
# rules of chess
class IllegalMoveError < StandardError
  def initialize(msg = 'Illegal Move')
    super
  end
end
