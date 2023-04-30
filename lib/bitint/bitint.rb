# frozen_string_literal: true

module BitInt
  # Indicates that +BitInt::new+ was called with an integer that was too large.
  class OverflowError < RuntimeError
    attr_reader :integer, :range
    def initialize(integer, range)
      super "#{integer} is out of bounds (range=#{range})"
      @integer = integer
      @range = range
    end
  end

  class BitInt < Numeric
    @classes = {}

    class << self
      private :new

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

      # Creates a new +BitInt+. Raises an ArgumentError if bits is negative.
      #
      # === Example
      #   puts BitInt[8]::MAX #=> 255
      #   puts BitInt[8, signed: false]::MAX #=> 255
      #   puts BitInt[8, signed: true]::MAX #=> 127
      def [](bits, signed: false)
        raise ArgumentError, "bit count must be positive" unless bits.positive?

        @classes[[bits, signed]] ||= Class.new(self) do |cls|
          cls.setup!(bits, signed)
        end
      end

      # Returns whether this class represents a signed integer.
      #
      # === Example
      #   puts BitInt::U(8).signed? #=> false
      #   puts BitInt::I(8).signed? #=> true
      def signed? = @signed

      # Returns whether this class represents an unsigned integer.
      #
      # === Example
      #   puts BitInt::U(8).unsigned? #=> false
      #   puts BitInt::I(8).unsigned? #=> true
      def unsigned? = !signed?

      def inspect = name || "#{signed? ? 'I' : 'U'}#@bits"
      alias to_s inspect

      # Masks +int+ for this class.
      def mask(int)
        ((int - self::MIN.to_i) & self::MASK) + self::MIN.to_i
      end

      # :stopdoc:
      protected def setup!(bits, signed)
        @bits = bits
        @signed = signed

        create = ->(int) {
          allocate.tap { |x| x.instance_variable_set :@int, int }
        }

        class << self
          public :new
        end

        const_set :BITS, @bits
        const_set :MASK, (1 << @bits).pred
        const_set :ZERO, create[0]
        const_set :ONE, create[1]
        const_set :MIN, create[signed? ? -(1 << @bits.pred) : 0]
        const_set :MAX, create[signed? ? (1 << @bits.pred).pred : (1 << @bits).pred]
        const_set :BOUNDS, self::MIN .. self::MAX
      end

      # :startdoc:
    end

    # Creates a new BitInt by masking +int+.
    #
    # If +int+ is not rdoc-ref:in_bounds? and +wrap+ is false, then an
    # OverflowError is raised.
    #
    # === Example
    #   puts BitInt::U(8).new(27) #=> 27
    #   puts BitInt::U(8).new(-1) #=> 255
    #   puts BitInt::U(8).new(-1, wrap: false) #=> OverflowError
    #   puts BitInt::I(8).new(255) #=> -1
    def initialize(int, wrap: true)
      cls = self.class
      if !wrap && !(bounds = cls::BOUNDS).include?(int)
        raise OverflowError.new(int, bounds)
      end

      @int = ((int - cls::MIN.to_i) & cls::MASK) + cls::MIN.to_i
    end

    # Checks to see if +rhs.to_i+ is equal to this class
    #
    # === Example
    #   U64 = BitInt::U(64)
    #   twelve = U64.new(12)
    # 
    #   # Behaves as you'd expect.
    #   puts twelve == U64.new(12) #=> true
    #   puts twelve == U64.new(13) #=> false
    #   puts twelve == 12   #=> true
    #   puts twelve == 12.0 #=> true
    #   puts twelve == 13   #=> false
    #   puts twelve == Object.new #=> false
    def ==(rhs)
      rhs.respond_to?(:to_i) && @int == rhs.to_i
    end

    # Overwite rdoc-ref:Numeric#integer? as we're an integer.
    def integer?
      true
    end

    # Gets the bit at index +idx+ or returns +nil+.
    #
    # This is equivalent to +Integer#[]+
    def [](idx)
      @int[idx]
    end

    # :section: Conversions

    # Returns the underlying integer.
    def to_i
      @int
    end
    alias to_int to_i

    # Converts self to a Float.
    def to_f
      @int.to_f
    end

    # Converts self to a String.
    #
    # If no base is given, it just returns a normal string in base 10.
    # If a base is given, a string padded with `0`s will be returned.
    def to_s(base = nil)
      return @int.to_s if base.nil?

      length = (self.class::BITS / Math.log2(base)).ceil
      case base
      when 2  then sprintf "%0#{length}b", @int
      when 8  then sprintf "%0#{length}o", @int
      when 16 then sprintf "%0#{length}x", @int
      else
      end
      if @int.negative? 
        (self.class::MAX.to_i + @int + 1).to_s(base)
      else
        (self.class::MAX.to_i + @int + 1).to_s(base)[1..]
      end.then { _1.rjust self.class::BITS / Math.log2(base), @int.negative? ? '1' : '0' }
    end
    alias inspect to_s

    # Returns a base-16 string of +self+. Equivalent to +to_s(16)+.
    #
    # If +upper: true+ is passed, returns an upper-case version.
    #
    # === Example
    #   puts BitInt::U16.new(1234).hex #=> 04d2
    #   puts BitInt::U16.new(1234, upper: true).hex #=> 04D2
    def hex(upper: false)
      h = to_s(16)
      upper ? h.upcase : h
    end

    # Returns a base-8 string of +self+. Equivalent to +to_s(8)+.
    #
    # === Example
    #   puts BitInt::U16.new(1234).oct #=> 02322
    def oct
      to_s(8)
    end

    # Returns a base-2 string of +self+. Equivalent to +to_s(2)+.
    #
    # === Example
    #   puts BitInt::U16.new(54321).bin #=> 0000010011010010
    def bin
      to_s(2)
    end

    # :section: Math

    # Numerically negates +self+.
    def -@
      self.class.new(-@int)
    end

    # Bitwise negates +self+.
    def ~
      self.class.new(~@int)
    end

    # Compares +self+ to +rhs+.
    def <=>(rhs)
      rhs.respond_to?(:to_i) ? @int <=> (_ = rhs).to_i : nil
    end

    # Adds +self+ to +rhs+.
    def +(rhs)
      self.class.new(@int + rhs.to_i)
    end

    # Subtracts +rhs+ from +self+.
    def -(rhs)
      self.class.new(@int - rhs.to_i)
    end

    # Multiplies +self+ by +rhs+.
    def *(rhs)
      self.class.new(@int * rhs.to_i)
    end

    # Divides +self+ by +rhs+.
    def /(rhs)
      self.class.new(@int / rhs.to_i)
    end

    # Modulos +self+ by +rhs+.
    def %(rhs)
      self.class.new(@int % rhs.to_i)
    end

    # Raises +self+ to the +rhs+th power.
    def **(rhs)
      # Note that `Numeric` only defines `.to_int` (not `.to_i`)
      self.class.new((@int ** rhs.to_i).to_int)
    end

    # Shifts +self+ left by +rhs+ bits.
    def <<(rhs)
      self.class.new(@int << rhs.to_i)
    end

    # Shifts +self+ right by +rhs+ bits.
    def >>(rhs)
      self.class.new(@int >> rhs.to_i)
    end

    # Bitwise ANDs +self+ and +rhs+.
    def &(rhs)
      self.class.new(@int & rhs.to_i)
    end

    # Bitwise ORs +self+ and +rhs+.
    def |(rhs)
      self.class.new(@int | rhs.to_i)
    end

    # Bitwise XORs +self+ and +rhs+.
    def ^(rhs)
      self.class.new(@int ^ rhs.to_i)
    end

    # :section:
  end
end
