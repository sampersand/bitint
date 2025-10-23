# frozen_string_literal: true

module BitInt
  module_function

  # Helper to create new unsigned {BitInt::Base} classes.
  #
  # This method just wraps {Base.create}
  #
  # @param bits [Integer] number of bits; must be nonzero
  # @return [subclass of Base] a +Class+ that inherits from +Base+
  #
  # @example
  #   puts BitInt::U(16)::MAX #=> 65535
  def U(bits) = Base.create(bits: bits, signed: false)
  alias unsigned U

  # Helper to create new signed {BitInt::Base} classes.
  #
  # This method just wraps {Base.create}
  #
  # @param bits [Integer] number of bits; must be nonzero
  # @return     [subclass of Base] a +Class+ that inherits from +Base+
  #
  # @example
  #   puts BitInt::I(16)::MAX #=> 32767
  def I(bits) = Base.create(bits: bits, signed: true)
  alias signed I
  alias S I

  # Helper to create new {BitInt::Base} classes.
  #
  # This method just wraps {Base.create}.
  #
  # @param bits   [Integer] number of bits; must be nonzero
  # @param signed [bool] whether the subclass should be signed
  # @return       [subclass of Base] a +Class+ that inherits from +Base+
  #
  # @example
  #   puts BitInt[9]::MAX #=> 511
  #   puts BitInt[9, signed: false]::MAX #=> 511
  #   puts BitInt[9, signed: true]::MAX #=> 255
  def [](bits, signed: false) = Base.create(bits: bits, signed: signed)
end
