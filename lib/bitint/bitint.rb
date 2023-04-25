module BitInt
  class OutOfBoundError
    attr_reader :integer, :min, :max
    def initialize(integer, min, max)
      super "Integer #{integer} is out of bounds (min=#{min}, max=#{max})"
      @integer = integer
      @min = min
      @max = max
    end
  end

  class BitInt
    # Checks to see if `integer` is in bounds.
    def self.in_bounds?(integer)
      (self::MIN..self::MAX).include?(integer)
    end

    # Creates a new unsigned `BitInt` class.
    def self.U(bits) = self[bits, signed: false]

    # Creates a new signed `BitInt` class.
    def self.I(bits) = self[bits, signed: true]

    def self.[](bits, signed: false)
      Class.new(self) do |cls|
        cls.setup!(bits, signed)
      end
    end

    # Returns whether this class represents a signed integer.
    def self.signed? = @signed

    # Returns whether this class represents an unsigned integer.
    def self.unsigned? = !signed?

    # Masks +int+ for this class.
    def self.mask(int)
      int.-(self::MIN.to_i).&(self::MASK) + self::MIN.to_i
    end


    class << self
      protected def setup!(bits, signed)
        @bits = bits
        @signed = signed

        create = ->(int) {
          allocate.tap { |x| x.instance_variable_set :@int, int }
        }

        const_set :MASK, (1 << @bits).pred
        const_set :ZERO, create[0]
        const_set :ONE, create[1]
        const_set :MIN, create[signed? ? -(1 << @bits.pred) : 0]
        const_set :MAX, create[signed? ? (1 << @bits.pred).pred : (1 << @bits).pred]
      end

      def inspect
        @name ||= name || "#{signed? ? 'I' : 'U'}#@bits"
      end
      alias to_s inspect
    end

    # Creates a new BitInt by masking +int+.
    #
    # If +int+ is {#in_bounds?} BitInt#in_bounds1 in_bounds? in_bounds1 #in_bounds? #in_bounds1
    #
    # = Example
    # If `wrap` is true, then integers that're out of bounds are
    # wrapped. If it's false, out of bound integers raise a `OutOfBound` exception.
    def initialize(int, wrap: true)
      if !wrap && !self.class.in_bounds?(int)
        raise OutOfBoundError.new(int, self::MIN, self::MAX)
      end

      @int = self.class.mask int
    end

    # :category: Foo

    # An unsigned 8-bit integer
    U8 = U(8)

    # An unsigned 16-bit integer
    U16 = U(16)
    # :section: hello

    # An unsigned 32-bit integer
    U32 = U(32)

    # An unsigned 64-bit integer
    U64 = U(64)

    # An unsigned 128-bit integer
    U128 = U(128)

    # A signed 8-bit integer
    I8 = I(8)

    # A signed 16-bit integer
    I16 = I(16)

    # A signed 32-bit integer
    I32 = I(32)

    # A signed 64-bit integer
    I64 = I(64)

    # A signed 128-bit integer
    I128 = I(128)

    # Negates `self`
    def -@ = self.class.new(-@int)
    def +@ = self.class.new(+@int)
    def ~  = self.class.new(~@int)

    def +(rhs)  = self.class.new(@int + rhs.to_i)
    def -(rhs)  = self.class.new(@int - rhs.to_i)
    def /(rhs)  = self.class.new(@int / rhs.to_i)
    def *(rhs)  = self.class.new(@int * rhs.to_i)
    def %(rhs)  = self.class.new(@int % rhs.to_i)
    def **(rhs) = self.class.new((@int ** rhs.to_i).to_i)
    def <<(rhs) = self.class.new(@int << rhs.to_i)
    def >>(rhs) = self.class.new(@int >> rhs.to_i)
    def &(rhs)  = self.class.new(@int & rhs.to_i)
    def |(rhs)  = self.class.new(@int | rhs.to_i)
    def ^(rhs)  = self.class.new(@int ^ rhs.to_i)

    def coerce(rhs) = [self.class.new(rhs), self]
    def to_i = @int
    alias to_int to_i
    def to_f = @int.to_f

    def to_s(base = nil)
      return @int.to_s if base.nil?
      @int.to_s(base).rjust(self.class::BITS / Math.log2(base), '0')
    end

    def hex = to_s(16)
    def oct = to_s(8)
    def bin = to_s(2)
    alias inspect bin
  end
end
