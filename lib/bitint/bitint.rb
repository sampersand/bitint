# frozen_string_literal: true

module BitInt
  module_function

  # Creates a new unsigned +BitInt::Base+ class.
  #
  # This is just a helper method that wraps +Base.create+
  #
  # === Example
  #   puts BitInt::U(16)::MAX #=> 65535
  def U(bits) = Base.create(bits: bits, signed: false)
  alias unsigned U

  # Creates a new signed +BitInt::Base+ class.
  #
  # This is just a helper method that wraps +Base.create+
  #
  # === Example
  #   puts BitInt::I(16)::MAX #=> 32767
  def I(bits) = Base.create(bits: bits, signed: true)
  alias signed I
  alias S I

  # Creates a new +BitInt::Base+ class.
  #
  # This is just a helper method that wraps +Base.create+
  #
  # === Example
  #   puts BitInt[9]::MAX #=> 511
  #   puts BitInt[9, signed: false]::MAX #=> 511
  #   puts BitInt[9, signed: true]::MAX #=> 255
  def [](bits, signed: false) = Base.create(bits: bits, signed: signed)
end
