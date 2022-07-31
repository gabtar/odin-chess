# frozen_string_literal: true

require_relative '../errors/invalid_coordinate'
require_relative '../errors/illegal_move'

# Class for chess board
#
# @attr squares [Array] Squares of the chess board
class Board
  attr_reader :squares

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
  end

  # Adds a piece to the board
  # @param piece [Piece] the piece that will be added
  # @param coordinate [String] the destination square in the chess board
  def add_piece(piece, coordinate)
    rank, file = parse_coordinate(coordinate)
    squares[rank][file] = piece
  end

  # Checks if the path if blocked by another piece in the board. Does not
  # check the destination square.
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  # @return [Boolean] if the path is blocked
  def blocked_path?(from, to)
    direction = calculate_direction_vector(from, to)
    current_square = next_square(from, direction)

    until current_square == to
      rank, file = parse_coordinate(current_square)
      return true unless squares[rank][file].nil?

      current_square = next_square(current_square, direction)
    end
    false
  end

  # Calculates the distance vector between +from+ and +to+ arguments in the board
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  def calculate_distance_vector(from, to)
    from_rank, from_file = parse_coordinate(from)
    to_rank, to_file = parse_coordinate(to)

    [to_rank - from_rank, to_file - from_file]
  end

  # Returns the unit vector for the path given
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  # @raise [IllegalMoveError] when it's not a valid path for a chess piece
  def calculate_direction_vector(from, to)
    distance_vector = calculate_distance_vector(from, to)

    # Check if not a diagonal or square direction from starting point (eg. from a1 to e2)
    if !distance_vector.include?(0) && distance_vector[0].abs != distance_vector[1].abs
      raise IllegalMoveError, 'Invalid movement direction'
    end

    distance_vector.map { |item| item.zero? ? 0 : item / item.abs }
  end

  # Validates if the passed colour is in check or not in the current position
  # @param army [String] the colour of the side we want to know if it's in check
  # @return [Boolean] true if its in check otherwise false
  def in_check?(army)
    king = @squares.flatten.select { |piece| !piece.nil? && piece.color == army && piece.is_a?(King) }.first

    king_coordinate = !king.nil? ? get_coordinate(king) : nil

    is_in_check = false
    @squares.flatten.each do |piece|
      if !piece.nil? && (piece.can_move_to?(self, get_coordinate(piece),
                                            king_coordinate) && piece.color != king.color)
        is_in_check = true
      end
    end

    is_in_check
  end

  # Returns the position in the +squares+ array for the given coordinate
  # @param coordinate [String] the board coordinate eg. 'a1'
  # @return [Array] a coordinates array containing [row, column] values
  #   representation of the chess board or InvalidCoordinateError if not exists
  # @raise [InvalidCoordinateError] when it's not a valid coordinate of a chess
  #   board
  def parse_coordinate(coordinate)
    if coordinate.length == 2
      file = coordinate[0].ord - 97
      rank = coordinate[1].to_i - 1
      return [rank, file] if rank.between?(0, squares.length) && file.between?(0, squares[0].length)
    end
    raise InvalidCoordinateError
  end

  # Returns the piece at the specified +coordinate+
  # @param coordinate [String]
  # @return [Piece, nil] the piece on the square or nil
  # @raise [InvalidCoordinateError] when it's not a valid coordinate of a chess
  #   board
  def get_piece_at(coordinate)
    rank, file = parse_coordinate(coordinate)
    squares[rank][file]
  end

  # Returns the string representing the current position of the pieces in the board
  def to_s
    board_str = ''
    squares.each do |row|
      row.each do |square|
        board_str += square.nil? ? ' ' : square
      end
      board_str += "\n"
    end
    board_str
  end

  private

  # Internal method for #blocked_path? returns the next square in the specified
  # +direction+
  def next_square(current_square, direction)
    rank, file = parse_coordinate(current_square)

    next_rank = rank + direction[0]
    next_file = file + direction[1]

    "#{(next_file + 97).chr}#{next_rank + 1}"
  end

  # Internal method for #in_check? that returns the cordinate or the pice or nil
  def get_coordinate(piece)
    coordinate = nil
    @squares.each_with_index do |rank, rank_index|
      rank.each_with_index do |file, file_index|
        coordinate = (97 + file_index).chr + (rank_index + 1).to_s if file.eql? piece
      end
    end
    coordinate
  end
end
