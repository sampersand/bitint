# frozen_string_literal: true

module BitInt
  module_function

  # Creates a new unsigned +BitInt+ class.
  #
  # === Example
  #   puts BitInt::U(16)::MAX #=> 65535
  def U(bits) = self[bits, signed: false]
  alias unsigned U

  # Creates a new signed +BitInt+ class.
  #
  # === Example
  #   puts BitInt::I(16)::MAX #=> 32767
  def I(bits) = self[bits, signed: true]
  alias signed I
  alias S I

  # Creates a new +BitInt+. Raises an ArgumentError if bits is negative.
  #
  # === Example
  #   puts BitInt[8]::MAX #=> 255
  #   puts BitInt[8, signed: false]::MAX #=> 255
  #   puts BitInt[8, signed: true]::MAX #=> 127
  def [](bits, signed: false) = Base.create(bits: bits, signed: signed)
end
