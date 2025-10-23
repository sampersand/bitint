# frozen_string_literal: true
# rbs_inline: enabled

module BitInt
  # @abstract Subclasses must be created via `Base.create`
  class Base < Numeric
    # :stopdoc:
    # List of classes; used in `create` to ensure duplicate classes for bits and signed-ness aren't created
    @classes = {} #: Hash[[Integer, bool], Class]
    # :startdoc:

    # @rbs self.@classes: Hash[[Integer, bool], Class]
    # @rbs self.@bits: Integer
    # @rbs self.@signed: bool
    # @rbs @wrap: bool
    # @rbs @int: Integer

    # @rbs!
    #    BITS: Integer
    #    BYTES: Integer
    #    MASK: Integer
    #    ZERO: Base
    #    ONE: Base
    #    MIN: Base
    #    MAX: Base
    #    BOUNDS: Range[Base]

    class << self

      # Creates a new {BitInt::Base} subclass.
      #
      # @param bits [Integer?] the amount of bits the subclass should have. Must be at least +1+.
      # @param bytes [Integer?] convenience argument; if supplied, sets +bits+ to +bytes * 8+. Cannot be used with +bits+
      # @param signed [bool] Whether the subclass is a signed.
      #
      # @return [singleton(Base)] A subclass of {BitInt::Base}; subclasses are cached, so repeated calls return the same subclass.
      #
      # @raise [ArgumentError] When +bits+ is negative or zero
      # @raise [ArgumentError] If both +bits+ and +bytes+ are supplied
      #
      # === Example
      #   puts BitInt::Base.create(bits: 8, signed: true).new(128)   #=> -127
      #   puts BitInt::Base.create(bytes: 1, signed: false).new(256) #=> 0
      #
      # @rbs (bits: Integer, signed: bool) -> untyped
      #    | (bytes: Integer, signed: bool) -> untyped
      def create(bits: nil, bytes: nil, signed:)
        if bits.nil? == bytes.nil?
          raise ArgumentError, "exactly one of 'bits' or 'bytes' must be supplied", caller(1)
        end

        bits ||= (_ = bytes) * 8

        unless bits.positive?
          raise ArgumentError, 'bit count must be positive', caller(1)
        end

        key = [bits, signed].freeze #: [Integer, bool]
        @classes[key] ||= Class.new(Base) do |cls|
          (_ = cls).setup!(bits, signed)
        end
      end

      # :stopdoc:
      # @rbs (Integer, bool) -> void
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
        const_set :BYTES, (@bits / 8.0).ceil
        const_set :MASK, (1 << @bits).pred
        const_set :ZERO, create[0]
        const_set :ONE, create[1]
        const_set :MIN, create[signed? ? -(1 << @bits.pred) : 0]
        const_set :MAX, create[signed? ? (1 << @bits.pred).pred : (1 << @bits).pred]
        const_set :BOUNDS, self::MIN .. self::MAX
      end
      # :startdoc:

      # Returns whether this class represents a signed integer.
      #
      # @abstract Only defined on subclasses
      #
      # === Example
      #   puts BitInt::U8.signed? #=> false
      #   puts BitInt::I8.signed? #=> true
      #
      # @rbs () -> bool
      def signed? = @signed

      # Returns whether this class represents an unsigned integer.
      #
      # @abstract Only defined on subclasses
      #
      # === Example
      #   puts BitInt::U8.unsigned? #=> true
      #   puts BitInt::I8.unsigned? #=> false
      #
      # @rbs () -> bool
      def unsigned? = !signed?

      # Returns a debugging string representation of this class
      #
      # If the class is one of the builtins (eg +BitInt::U16+), it uses its name
      # as the string, otherwise it uses a debugging representation
      #
      # === Example
      #    p BitInt::U16   #=> BitInt::U16
      #    p BitInt::U(17) #=> #<BitInt::Base @bits=17 @signed=false>
      #
      # @rbs () -> String
      def inspect = name || "#<BitInt::Base @bits=#@bits @signed=#@signed>"
      alias to_s inspect

      # Wraps an +integer+ to be within the bounds of +self+
      #
      # @param integer [Integer] the integer to wrap
      # @return [Integer] an integer guaranteed to be within +self::BOUNDS+.
      #
      # @abstract Only defined on subclasses
      #
      # === Example
      #     puts BitInt::I8.wrap(127) #=> 127
      #     puts BitInt::I8.wrap(128) #=> -128
      #     puts BitInt::I8.wrap(0xFF_FF_FF_FF_FF) #=> -1
      #
      # @rbs (Integer) -> Integer
      def wrap(integer)
        ((integer - self::MIN.to_i) & self::MASK) + self::MIN.to_i
      end

      # Check to see if +integer+ is in bounds for +self+
      #
      # @abstract Only defined on subclasses
      #
      # @param integer [Integer] the integer to check
      # @return [bool] whether the integer is in bounds
      #
      # === Example
      #     puts BitInt::I16.in_bounds?(32767) #=> true
      #     puts BitInt::I16.in_bounds?(32768) #=> false
      #     puts BitInt::U32.in_bounds?(-1)     #=> false
      #
      # @rbs (Integer) -> bool
      def in_bounds?(integer)
        # TODO: use `self::BOUNDS`
        (self::MIN.to_i .. self::MAX.to_i).include? integer
      end
    end

    # Creates a new instance with the +integer+.
    #
    # @param integer [Integer] the integer to use
    # @param wrap [bool] changes how {Base.in_bounds? out-of-bounds} integers are handled. When true,
    #                    they're {Base.wrap wrapped}; when false, an +OverflowError+ to be raised.
    # @raise [OverflowError] raised when +wrap+ is +false+ and +integer+ is out of bounds.
    #
    # === Example
    #   puts BitInt::U8.new(27) #=> 27
    #   puts BitInt::U8.new(-1) #=> 255
    #   puts BitInt::U8.new(-1, wrap: false) #=> OverflowError
    #   puts BitInt::I8.new(255) #=> -1
    #
    # @rbs (Integer, ?wrap: boolish) -> void
    def initialize(integer, wrap: true)
      unless wrap || self.class.in_bounds?(integer)
        exc = OverflowError.new(integer, self.class::BOUNDS)
        exc.set_backtrace(
          caller_locations(1) #: Array[Thread::Backtrace::Location]
        )
        raise exc
      end

      @int = self.class.wrap(integer)
      @wrap = wrap
    end

    ################################################################################################
    #                                         Conversions                                          #
    ################################################################################################

    # :section: Conversions

    # Returns the underlying integer.
    #
    # @rbs () -> Integer
    def to_i = @int
    alias to_int to_i

    # Converts +self+ to a +Float+.
    #
    # @rbs () -> Float
    def to_f = @int.to_f

    # Converts +self+ to a +Rational+.
    #
    # @rbs () -> Rational
    def to_r = @int.to_r

    # (no need for `.to_c` as `Numeric` defines it)

    # Converts +self+ to a +String+.
    #
    # If no +base+ is given, it just returns a normal String in base 10.
    # If a base is given, a string padded with `0`s will be returned.
    #
    # === Examples
    #    puts BitInt::U16.new(1234).to_s     #=> 1234
    #    puts BitInt::U16.new(1234).to_s(16) #=> 04d2
    #
    # @rbs (?int? base) -> String
    def to_s(base = nil)
      return @int.to_s unless base
      base = base.to_int

      adjusted = negative? ? (-2*self.class::MIN.to_i + @int).to_i : @int
      adjusted.to_s(base).rjust(self.class::BITS / Math.log2(base), negative? ? '1' : '0')
    end
    alias inspect to_s

    # Returns a base-16 string of +self+. Equivalent to +to_s(16)+.
    #
    # If +upper: true+ is passed, returns an upper-case version.
    #
    # === Examples
    #   puts BitInt::U16.new(1234).hex #=> 04d2
    #   puts BitInt::U16.new(1234, upper: true).hex #=> 04D2
    #
    # @rbs (?upper: boolish) -> String
    def hex(upper: false) = to_s(16).tap { _1.upcase! if upper }

    # Returns a base-8 string of +self+. Equivalent to +to_s(8)+.
    #
    # === Example
    #   puts BitInt::U16.new(12345).oct #=> 30071
    #
    # @rbs () -> String
    def oct = to_s(8)

    # Returns a base-2 string of +self+. Equivalent to +to_s(2)+.
    #
    # === Example
    #   puts BitInt::U16.new(54321).bin #=> 0000010011010010
    #
    # @rbs () -> String
    def bin = to_s(2)

    # Converts +other+ to an instance of +self+, and returns a tuple of +[<converted>, self]+
    #
    # @rbs (int) -> [instance, self]
    def coerce(other) = [new_instance(other.to_int), self]

    ################################################################################################
    #                                             ...                                              #
    ################################################################################################

    # Checks to see if +rhs+ is equal to +selF+
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
    #
    # @rbs (untyped) -> boolish
    def ==(rhs)
      defined?(rhs.to_i) && @int == rhs.to_i
    end

    # Checks to see if +rhs+ is another +BitInt::Base+ of the same class, and
    # have the same contents.
    #
    # @rbs (untyped) -> bool
    def eql?(rhs)
      rhs.is_a?(self.class) && @int == rhs.to_i
    end

    # Returns a hash code for this class.
    #
    # @rbs () -> Integer
    def hash = [self.class, @int].hash

    # Always return +true+, as +BitInt::Base+s are always integers.
    #
    # @rbs () -> true
    def integer? = true

    # @rbs (Integer, ?wrap: bool) -> instance
    private def new_instance(int, wrap: @wrap) = self.class.new(int, wrap:)

    ################################################################################################
    #                                             Math                                             #
    ################################################################################################

    # Numerically negates +self+.
    #
    # @rbs () -> instance
    def -@ = new_instance(-@int)

    # Compares +self+ to +rhs+.
    #
    # @rbs (_ToI) -> (-1 | 0 | 1)
    #    | (untyped) -> Integer?
    def <=>(rhs) = defined?(rhs.to_i) ? @int <=> (_ = rhs).to_i : nil

    # Adds +self+ to +rhs+.
    #
    # @rbs (int) -> instance
    def +(rhs) = new_instance(@int + rhs.to_int)

    # Subtracts +rhs+ from +self+.
    #
    # @rbs (int) -> instance
    def -(rhs) = new_instance(@int - rhs.to_int)

    # Multiplies +self+ by +rhs+.
    #
    # @rbs (int) -> instance
    def *(rhs) = new_instance(@int * rhs.to_int)

    # Divides +self+ by +rhs+.
    #
    # @rbs (int) -> instance
    def /(rhs) = new_instance(@int / rhs.to_int)

    # Modulos +self+ by +rhs+.
    #
    # @rbs (int) -> instance
    def %(rhs) = new_instance(@int % rhs.to_int)

    # Raises +self+ to the +rhs+th power.
    #
    # @rbs (int) -> instance
    def **(rhs) = new_instance((@int ** rhs.to_int).to_int) # TODO: use `Integer#pow(int, int)`

    # :section:

    # Returns whether +self+ is a positive integer. Zero is not positive.
    #
    # @rbs () -> bool
    def positive? = @int.positive?

    # Return whether +self+ is a negative integer. Zero is not negative.
    #
    # @rbs () -> bool
    def negative? = @int.negative?

    # Returns whether +self+ is zero.
    #
    # @rbs () -> bool
    def zero? = @int.zero?

    # Returns a falsey value if zero, otherwise returns +self+.
    #
    # @rbs () -> self?
    def nonzero? = @int.nonzero? && self

    # Checks to see if +self+ is even.
    #
    # @rbs () -> bool
    def even? = @int.even?

    # Checks to see if +self+ is odd.
    #
    # @rbs () -> bool
    def odd? = @int.odd?

    # Same as +Integer#times+, but returns instances of +self+.
    #
    # @rbs () -> Enumerator[instance, self]
    #    | () { (instance) -> void } -> self
    def times
      return to_enum(_ = __method__) unless block_given?

      @int.times do |int|
        yield new_instance int
      end

      self
    end

    # Same as +Integer#downto+, but returns instances of +self+.
    #
    # @rbs (Numeric) -> Enumerator[instance, self]
    #    | (Numeric) { (instance) -> void } -> self
    def downto(what)
      return to_enum(_ = __method__) unless block_given?

      @int.downto what do |int|
        yield new_instance int
      end

      self
    end

    # Same as +Integer#downto+, but returns instances of +self+.
    #
    # @rbs (Numeric) -> Enumerator[instance, self]
    #    | (Numeric) { (instance) -> void } -> self
    def upto(what)
      return to_enum(_ = __method__) unless block_given?

      @int.upto what do |int|
        yield new_instance int
      end

      self
    end

    # Gets the next value, or throws a {OverFlowError} if at the top.
    #
    # @rbs () -> instance
    def succ
      # TODO: this changes `@wrap`; that's weird
      new_instance(@int + 1, wrap: false)
    end

    # Gets the next value, or throws a {OverFlowError} if at the top.
    #
    # @rbs () -> instance
    def pred
      # TODO: this changes `@wrap`; that's weird
      new_instance(@int - 1, wrap: false)
    end

      ## TODO: SUCC

    ################################################################################################
    #                                       Bitwise Methods                                        #
    ################################################################################################

    # Bitwise negates +self+.
    #
    # @rbs () -> instance
    def ~ = new_instance(~@int)

    # Shifts +self+ left by +rhs+ bits.
    #
    # @rbs (int) -> instance
    def <<(rhs) = new_instance(@int << rhs.to_int)

    # Shifts +self+ right by +rhs+ bits.
    #
    # @rbs (int) -> instance
    def >>(rhs) = new_instance(@int >> rhs.to_int)

    # Bitwise ANDs +self+ and +rhs+.
    #
    # @rbs (int) -> instance
    def &(rhs) = new_instance(@int & rhs.to_int)

    # Bitwise ORs +self+ and +rhs+.
    #
    # @rbs (int) -> instance
    def |(rhs) = new_instance(@int | rhs.to_int)

    # Bitwise XORs +self+ and +rhs+.
    #
    # @rbs (int) -> instance
    def ^(rhs) = new_instance(@int ^ rhs.to_int)

    # Gets the bit at index +idx+ or returns +nil+.
    #
    # This is equivalent to +Integer#[]+
    # @rbs (int, ?int) -> Integer?
    #    | (range[int]) -> Integer?
    def [](...) = __skip__ = @int.[](...)

    # Returns true if any bit in `mask` is set in +self+.
    #
    # @rbs (int) -> bool
    def anybits?(mask) = @int.anybits?(mask)

    # Returns true if all bits in `mask` are set in +self+.
    #
    # @rbs (int) -> bool
    def allbits?(mask) = @int.allbits?(mask)

    # Returns true if no bits in `mask` are set in +self+.
    #
    # @rbs (int) -> bool
    def nobits?(mask) = @int.nobits?(mask)

    # Returns the amount of bits required to represent +self+
    #
    # Unlike +Integer#bit_length+, this never changes and is equivalent
    # to +self.class::BITS+.
    #
    # @rbs () -> Integer
    def bit_length = self.class::BITS

    # Returns the amount of bytes required to represent +self+
    #
    # This is equivalent to +self.class::BYTES+
    #
    # @rbs () -> Integer
    def byte_length = self.class::BYTES

    # Returns all the bytes that're used represent +self+
    #
    # @rbs (?:native | :big | :little) -> Array[U8]
    def bytes(endian = :native)
      each_byte(endian).to_a
    end

    # Executes the block once for each byte in +self+.
    #
    # Bytes are converted to +U8+. If no block is given, returns an +Enumerator+
    #
    # @rbs (?:native | :big | :little) { (U8) -> void } -> self
    #    | (?:native | :big | :little) -> Enumerator[U8, self]
    def each_byte(endian = :native)
      return to_enum(_ = __method__, endian) unless block_given?

      template = '_CS_L___Q'[self.class::BYTES]
      if template.nil? || template == '_'
        raise ArgumentError, 'bytes only works for sizes of 8, 16, 32, or 64.'
      end

      template.downcase! if self.class.signed?

      case endian
      when :native then # do nothing
      when :little then template.concat '<' unless self.class::BYTES == 1
      when :big    then template.concat '>' unless self.class::BYTES == 1
      else
        raise ArgumentError, 'endian must be :big, :little, or :native'
      end

      [@int].pack(template).unpack('C*').each do |byte| #: Integer
        yield U8.new(byte)
      end

      self
    end
  end
end
