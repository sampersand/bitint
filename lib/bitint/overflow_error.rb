# frozen_string_literal: true
# rbs_inline: enabled

module BitInt
  # Indicates that +BitInt::Base.create+ was called with an integer that was too large.
  class OverflowError < RuntimeError
    attr_reader :integer, :range

    def initialize(integer, range)
      super "#{integer} is out of bounds (range=#{range})"
      @integer = integer
      @range = range
    end
  end
end
