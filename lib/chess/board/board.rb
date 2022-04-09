# frozen_string_literal: true

require_relative '../errors/invalid_coordinate'
require_relative '../errors/illegal_move'

# Class for chess board
#
# @author Full Name
# @attr [Types] attribute_name a full description of the attribute
# @attr_reader [Types] name description of a readonly attribute
# @attr_writer [Types] name description of writeonly attribute
class Board
  attr_reader :squares

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
  end

  def add_piece(piece, coordinate)
    rank, file = parse_coordinate(coordinate)
    squares[rank][file] = piece
  end

  # Check if its a valid move according to chess rules
  def validate_move(from, to)
    from_rank, from_file = parse_coordinate(from)

    piece = squares[from_rank][from_file]

    raise IllegalMoveError if !piece.can_move?(self, from, to) || blocked_path?(from, to)
  end

  # Checks if the path if blocked by another piece in the board. Does not check the destination square.
  def blocked_path?(from, to)
    current_rank, current_file = parse_coordinate(from)
    to_rank, to_file = parse_coordinate(to)

    direction = calculate_direction_vector(from, to)
    blocked_path = false

    until current_rank == to_rank && current_file == to_file || blocked_path
      current_rank += direction[0]
      current_file += direction[1]

      blocked_path = true unless squares[current_rank][current_file].nil?
    end
    blocked_path
  end

  # Calculates the distance vector between from and to arguments in the board
  # returns vector [rank, file]
  def calculate_distance_vector(from, to)
    from_rank, from_file = parse_coordinate(from)
    to_rank, to_file = parse_coordinate(to)

    [to_rank - from_rank, to_file - from_file]
  end

  # Returns the unit direction vector
  # In the form [rank, file]
  def calculate_direction_vector(from, to)
    distance_vector = calculate_distance_vector(from, to)

    # Check if not a diagonal or square direction from starting point (eg. from a1 to e2)
    # TODO, unless if its a horse!!!
    raise IllegalMoveError.new('Invalid direction') if !distance_vector.include?(0) && distance_vector[0].abs != distance_vector[1].abs

    distance_vector.map { |item| item.zero? ? 0 : item / item.abs }
  end

  # # TODO, Converts current board position to FEN notation string
  # def serialize
  # end

  # Returns the position in the +squares+ array for the given coordinate
  #
  # @param coordinate [String] the board coordinate eg. 'a1' @return [Array] array containing [row, column] for the internal
  # representation of the chess board or InvalidCoordinateError if not exists
  def parse_coordinate(coordinate)
    if coordinate.length == 2
      file = coordinate[0].ord - 97
      rank = coordinate[1].to_i - 1
      return [rank, file] if rank.between?(0, squares.length) && file.between?(0, squares[0].length)
    end
    raise InvalidCoordinateError
  end
end
