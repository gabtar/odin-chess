# frozen_string_literal: true

# Error for invalid board coordinates, not in range a-f or 1-8
class InvalidCoordinateError < StandardError
  def initialize(msg = 'Invalid board coordinate')
    super
  end
end
