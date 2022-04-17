# frozen_string_literal: true

require_relative '../errors/invalid_coordinate'
require_relative '../errors/illegal_move'
# require 'pry-byebug'

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

  # Check if its a valid move according to chess rules
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  # @raise [IllegalMoveError] when it's not a valid move
  def validate_move(from, to)
    # TODO, on destination square if there is a opponent Piece
    # same color piece or empty square

    # Types/checks:
    # move -> Rules for each piece!!!
    # capture
    # castle
    # en passant
    # queening

    from_piece = get_piece_at(from)
    to_piece = get_piece_at(to)

    if to_piece.nil? || from_piece.color != to_piece.color
      # can displace to or capture
      raise IllegalMoveError unless get_piece_at(from).can_move_to?(self, from, to)
    else
      # cannot displace to
      raise IllegalMoveError, "Illegal move #{from} cant go to #{to}"
    end
  end

  # Checks if the path if blocked by another piece in the board. Does not
  # check the destination square.
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  # @return [Boolean] if the path is blocked
  def blocked_path?(from, to)
    current_rank, current_file = parse_coordinate(from)
    to_rank, to_file = parse_coordinate(to)

    direction = calculate_direction_vector(from, to)
    blocked_path = false

    until current_rank == to_rank - direction[0] && current_file == to_file - direction[1] || blocked_path
      current_rank += direction[0]
      current_file += direction[1]

      blocked_path = true unless squares[current_rank][current_file].nil?
    end
    # # TODO, need to check attacked squares
    # blocked_path = true if !get_piece_at(to).nil? && !get_piece_at(from).nil? && get_piece_at(from).color == get_piece_at(to).color
    blocked_path
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

  # Checks if the +square+ coordinate passed is defended by the passed +army+ on the board
  # @param square [String] the coordinate of the square we want to know if its defended
  # @param army [String] the color of the army we want to know if they are defending the square
  # TODO New square Abstraction
  def defended?(square, army)
    # rank = 0
    # file = 0
    # squares.any? do |row|
    #   row.any? do |piece|
    #     coordinate = (97 + rank).chr + (file + 1).to_s
    #     p coordinate
    #     !piece.nil? && piece.color == army && piece.defends_square?(self, coordinate, square)
    #     file += 1
    #   end
    #   rank += 1
    # end
    defended = false
    squares.each_with_index do |rank, rank_index|
      rank.each_with_index do |file, file_index|
        coordinate = (97 + file_index).chr + (rank_index + 1).to_s

        defended = true if !file.nil? && file.color == army && file.defends_square?(self, coordinate, square)
      end
    end
    defended
  end

  # # TODO, Converts current board position to FEN notation string
  # def serialize
  # end

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
end
