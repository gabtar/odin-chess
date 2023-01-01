# frozen_string_literal: true

# Helper funtions for TUI
module GameReporter
  # Retunrs an string with the board, captured pieces, player to move and other game status
  # @attr game [Game] the chess game
  def board_status(game)
    black_computer = game.black_player.is_a?(ComputerPlayer) ? ' (Computer)' : ''
    white_computer = game.white_player.is_a?(ComputerPlayer) ? ' (Computer)' : ''

    board_str = "------------------------------------ \n"
    board_str += @game.result ? " RESULT: #{game.result} \n" : "           TO MOVE: #{game.turn.color} \n"
    board_str += "------------------------------------ \n"

    if white_computer.empty?
      # Print from white point of view
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
    else
      # Print from black point of view
      board_str += "            White Player#{white_computer}\n"
      board_str += "\n  |-------------------------------|\n"
      game.board.squares.each_with_index do |row, index|
        board_str += "#{index + 1} |"
        row.reverse.each do |square|
          board_str += square.nil? ? '   |' : " #{square} |"
        end
        board_str += "\n  |-------------------------------|\n"
      end
      board_str += "    h   g   f   e   d   c   b   a\n\n"
      board_str += "           Black Player#{black_computer}\n"
    end
  end

  # Retunrs an string with the last numbers of moves
  # @attr max_number_of_moves [Integer] the maximun number moves to display in screen
  # @attr list_of_moves [Array] the list of moves the game
  def moves_status(list_of_moves, max_number_of_moves_to_display)
    moves = list_of_moves
    move_number = 0
    # Group moves by pair
    total_number_of_moves = (list_of_moves.length / 2).ceil

    if total_number_of_moves > max_number_of_moves_to_display
      move_number += ((list_of_moves.length - max_number_of_moves_to_display * 2) / 2).ceil
      move_number += 1 if list_of_moves.length.odd?
      moves = moves[(move_number * 2)..list_of_moves.length]
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
