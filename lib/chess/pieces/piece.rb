# frozen_string_literal: true

# Basic class for chess piecess
#
# @author Full Name
# @attr [Types] attribute_name a full description of the attribute
# @attr_reader [Types] name description of a readonly attribute
# @attr_writer [Types] name description of writeonly attribute
#
class Piece
  attr_reader :color

  def initialize(color, jump = false)
    @color = color
    @jump = jump
  end

  def can_move?(board, from, to)
    false
  end
end
