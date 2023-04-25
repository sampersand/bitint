module BitInt
  module Refinements
    refine Integer do
      def U(size) = BitInt::U(size).new(self)
      def I(size) = BitInt::I(size).new(self)

      def u8   = Bitint::U8.new(self)
      def u16  = Bitint::U16.new(self)
      def u32  = Bitint::U32.new(self)
      def u64  = Bitint::U64.new(self)
      def u128 = Bitint::U128.new(self)

      def i8   = Bitint::I8.new(self)
      def i16  = Bitint::I16.new(self)
      def i32  = Bitint::I32.new(self)
      def i64  = Bitint::I64.new(self)
      def i128 = Bitint::I128.new(self)
    end
  end
end
