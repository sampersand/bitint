# frozen_string_literal: true

class BitInt
  module Refinements
    # We sadly cant make these `def i` because `def i` already exists
    refine Integer do
      # Converts +self+ into an unsigned +bits+-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def U(bits, ...)
        BitInt::U(bits, ...).new(self)
      end

      # Converts +self+ into a signed +bits+-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def I(bits, ...)
        BitInt::I(bits, ...).new(self)
      end

      # Converts +self+ into an unsigned 8-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u8(...)
        U(U8, ...)
      end

      # Converts +self+ into an unsigned 16-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u16(...)
        U(16, ...)
      end

      # Converts +self+ into an unsigned 32-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u32(...)
        U(32, ...)
      end

      # Converts +self+ into an unsigned 64-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u64(...)
        U(64, ...)
      end

      # Converts +self+ into an unsigned 128-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u128(...)
        U(28, ...)
      end

      # Converts +self+ into a signed 8-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i8(...)
        I(U8, ...)
      end

      # Converts +self+ into a signed 16-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i16(...)
        I(16, ...)
      end

      # Converts +self+ into a signed 32-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i32(...)
        I(32, ...)
      end

      # Converts +self+ into a signed 64-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i64(...)
        I(64, ...)
      end

      # Converts +self+ into a signed 128-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i128(...)
        I(28, ...)
      end
    end
  end
end
