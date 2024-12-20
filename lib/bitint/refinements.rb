# frozen_string_literal: true

class BitInt
  # Refinements to Integer for easy "BitInt literals" (eg `12.u8`)
  module Refinements
    refine Integer do
      # Converts +self+ into an unsigned +bits+-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      #
      # === Examples
      #   puts BitInt::U(16)::MAX #=> 65535
      #   
      def u(bits, ...)
        BitInt::U(bits, ...).new(self)
      end

      # Converts +self+ into a signed +bits+-bit integer.
      #
      # If no arguments are given, this instead forwards to Numeric#i.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i(bits = bits_not_given=true, *a, **k, &b) # Support ruby-3.0
        bits_not_given and return super

        BitInt::i(bits, *a, **k, &b).new(self)
      end

      # Converts +self+ into an unsigned 8-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u8(...) = u(8, ...)

      # Converts +self+ into an unsigned 16-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u16(...) = u(16, ...)

      # Converts +self+ into an unsigned 32-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u32(...) = u(32, ...)

      # Converts +self+ into an unsigned 64-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u64(...) = u(64, ...)

      # Converts +self+ into an unsigned 128-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u128(...) = u(128, ...)

      # Converts +self+ into a signed 8-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i8(...) = i(8, ...)

      # Converts +self+ into a signed 16-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i16(...) = i(16, ...)

      # Converts +self+ into a signed 32-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i32(...) = i(32, ...)

      # Converts +self+ into a signed 64-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i64(...) = i(64, ...)

      # Converts +self+ into a signed 128-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i128(...) = i(128, ...)
    end
  end
end
