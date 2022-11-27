# frozen_string_literal: true

# Helper funtions for TUI
module GameReporter

  # Retunrs an string with the board, captured pieces, player to move and other game status
  # @attr board [Game] the board with the current position of the game
  def board_status(game)
    board_str = "------------------------------------ \n"
    board_str += "           TO MOVE: #{game.turn} \n"
    board_str += "------------------------------------ \n"

    board_str += "           Black Player\n"
    board_str += "\n  |-------------------------------|\n"
    game.board.squares.reverse.each_with_index do |row, index|
      board_str += "#{8 - index} |"
      row.each do |square|
        board_str += square.nil? ? '   |' : " #{square} |"
      end
      board_str += "\n  |-------------------------------|\n"
    end
    board_str += "    a   b   c   d   e   f   g   h\n\n"
    board_str += "            White Player\n"
  end

  def moves_status(game)
    # TODO, use Algebraic Notation when displaying moves
    moves_str = "Moves list\n"
    moves_str += "------------\n"
    move_number = 1
    game.moves_list.each_slice(2) do |move|
      move_list = move.map { |m| m.long_algebraic_notation }
      moves_str += "#{move_number}. #{move_list}\n"
      move_number += 1
    end
    moves_str
  end
end
