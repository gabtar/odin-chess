# frozen_string_literal: true

# Helper funtions for TUI
module GameReporter
  # Retunrs an string with the board, captured pieces, player to move and other game status
  # @attr board [Game] the board with the current position of the game
  def board_status(game)
    black_computer = game.black_player.is_a?(ComputerPlayer) ? ' (Computer)' : ''
    white_computer = game.white_player.is_a?(ComputerPlayer) ? ' (Computer)' : ''

    board_str = "------------------------------------ \n"
    board_str += "           TO MOVE: #{game.turn.color} \n"
    board_str += "------------------------------------ \n"

    board_str += "           Black Player#{black_computer}\n"
    board_str += "\n  |-------------------------------|\n"
    game.board.squares.reverse.each_with_index do |row, index|
      board_str += "#{8 - index} |"
      row.each do |square|
        board_str += square.nil? ? '   |' : " #{square} |"
      end
      board_str += "\n  |-------------------------------|\n"
    end
    board_str += "    a   b   c   d   e   f   g   h\n\n"
    board_str += "            White Player#{white_computer}\n"
  end

  # Retunrs an string with the last numbers of moves
  # @attr max_number_of_moves [Integer] the board with the current position of the game
  # @attr game [Game] the game of chess
  def moves_status(game, max_number_of_moves_to_display)
    moves = game.moves_list
    move_number = 0
    total_number_of_moves = (moves.length / 2).ceil

    if total_number_of_moves > max_number_of_moves_to_display
      move_number += ((game.moves_list.length - max_number_of_moves_to_display * 2) / 2).ceil
      move_number += 1 if game.moves_list.length.odd?
      moves = moves[(move_number * 2)..moves.length]
    end

    moves_str = "Moves list\n"
    moves_str += "------------\n"
    moves.each_slice(2) do |move|
      move_number += 1
      move_list = move.map(&:notation)
      moves_str += "#{move_number}. #{move_list.join(',  ')}\n"
    end
    moves_str
  end
end
