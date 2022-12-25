# frozen_string_literal: true

require 'deep_clone'

require_relative '../errors/invalid_coordinate'
require_relative '../errors/illegal_move'
require_relative '../moves/move_creator'

# Class for chess board
class Board
  include MoveCreator

  attr_reader :squares
  attr_accessor :last_move, :to_move

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
    @to_move = 'white'
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
      return true unless get_piece_at(current_square).nil?

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

  # Checks if the path +from+ square +to+ square is attacked by opposite army
  # Used for castle validation
  # @param from [String] the starting square coordinate
  # @param to [String] the destination square coordinate
  # @param army [String] the color of the side we want to know if the path is attacked
  def path_attacked?(from, to, army)
    direction = calculate_direction_vector(from, to)
    current_square = next_square(from, direction)

    until current_square == to
      @squares.flatten.each do |piece|
        next if piece.nil? || piece.color == army

        return true if piece.can_move_to?(self, get_coordinate(piece),
                                          current_square) && !blocked_path?(get_coordinate(piece), current_square)
      end
      current_square = next_square(current_square, direction)
    end
    false
  end

  # Validates if the passed colour if current player is in check or not in the current position
  # @param army [String] the colour of the side we want to know if it's in check
  # @return [Boolean] true if its in check otherwise false
  def in_check?(_board, army)
    board_clone = DeepClone.clone(self)
    opponent_pieces = board_clone.pieces(army == 'white' ? 'black' : 'white')
    king = board_clone.pieces(army).select { |piece| piece.is_a?(King) }.first

    # Refactor with pieces method
    opponent_pieces.each do |piece|
      from = board_clone.get_coordinate(piece)

      move = create_move(from, board_clone.get_coordinate(king), board_clone)
      begin
        # Found a move that can capture the king
        move.validate
        return true
      rescue StandardError => e
        # Its an invalid move, so as it cannot be performed, is not in check
        # Continue looking for captures moves
        next
      end
    end
    false
  end

  # Returns the current board as a FEN string
  # Only returns the first part of FEN without the halfmove clock and without
  # the fullmove number
  # Used for checking in threefold_repetition? method
  # @return [String] the actual position of the board
  def to_fen
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR
    fen_string = ''

    # Pieces position
    @squares.reverse.each_with_index do |row, index|
      blank_squares = 0
      row.each do |piece|
        if piece.nil?
          blank_squares += 1
        else
          fen_string += blank_squares.to_s unless blank_squares.zero?
          fen_string += piece.fen_representation
          blank_squares = 0
        end
      end
      fen_string += blank_squares.to_s unless blank_squares.zero?
      fen_string += '/' unless index == 7
    end

    # Side to move
    fen_string += " #{@to_move[0]}"

    # Castling availability
    fen_string += " #{available_castles}"

    # En passant target square
    en_passant_target_square = @last_move.is_a?(FirstPawnMove) ? @last_move.en_passant_target_square : nil
    fen_string += " #{en_passant_target_square.nil? ? '-' : en_passant_target_square}"

    fen_string
  end

  # Returns the pieces of the passed +army+ on the board
  # @param army [String] the color of the army the pieces we want
  # @return [Array] an array of containing all pieces on the board of the army
  def pieces(army)
    @squares.flatten.select { |piece| !piece.nil? && piece.color == army }
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

  # Returns the square where the passed +piece+ is located
  # @param piece [Piece]
  # @return [String, nil] the coordinate of the piece
  def get_coordinate(piece)
    coordinate = nil
    @squares.each_with_index do |rank, rank_index|
      rank.each_with_index do |file, file_index|
        coordinate = (97 + file_index).chr + (rank_index + 1).to_s if file.eql? piece
      end
    end
    coordinate
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

  # Returns the available castles in the position for FEN notation
  # Checks only if the castle pieces havent been already moved
  # It doesn't matter if its legal or not, FEN notation just
  # only determines if it's available
  def available_castles
    available_castles = ''
    # For white
    king = get_piece_at('e1')

    if king.is_a?(King) && king.color == 'white' && !king.moved
      # Kingside
      rook = get_piece_at('h1')
      available_castles += 'K' if rook.is_a?(Rook) && rook.color == 'white' && !rook.moved
      # Queenside
      rook = get_piece_at('a1')
      available_castles += 'Q' if rook.is_a?(Rook) && rook.color == 'white' && !rook.moved
    end

    # For black
    king = get_piece_at('e8')
    if king.is_a?(King) && king.color == 'black' && !king.moved
      # Kingside
      rook = get_piece_at('h8')
      available_castles += 'k' if rook.is_a?(Rook) && rook.color == 'black' && !rook.moved
      # Queenside
      rook = get_piece_at('a8')
      available_castles += 'q' if rook.is_a?(Rook) && rook.color == 'black' && !rook.moved
    end

    available_castles.empty? ? '-' : available_castles
  end
end
