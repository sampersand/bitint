# frozen_string_literal: true
# rbs_inline: enabled

module BitInt
  # Refinements to +Integer+ for easy "+BitInt+ literals" (eg +puts(12.u8)+)
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
        BitInt::U(bits).new(self, ...)
      end

      # Converts +self+ into a signed +bits+-bit integer.
      #
      # If no arguments are given, this instead forwards to Numeric#i.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i(bits = bits_not_given=true, ...)
        bits_not_given and return super()

        BitInt::I(bits).new(self, ...)
      end

      # Converts +self+ into an unsigned 8-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u8(...) = U8.new(self, ...)

      # Converts +self+ into an unsigned 16-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u16(...) = U16.new(self, ...)

      # Converts +self+ into an unsigned 32-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u32(...) = U32.new(self, ...)

      # Converts +self+ into an unsigned 64-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u64(...) = U64.new(self, ...)

      # Converts +self+ into an unsigned 128-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def u128(...) = U128.new(self, ...)

      # Converts +self+ into a signed 8-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i8(...) = I8.new(self, ...)

      # Converts +self+ into a signed 16-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i16(...) = I16.new(self, ...)

      # Converts +self+ into a signed 32-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i32(...) = I32.new(self, ...)

      # Converts +self+ into a signed 64-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i64(...) = I64.new(self, ...)

      # Converts +self+ into a signed 128-bit integer.
      #
      # Any additional arguments are forwarded to +BitInt#new+
      def i128(...) = I128.new(self, ...)
    end
  end
end
