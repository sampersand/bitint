module BitInt
  class Base < Numeric
    @classes = {}

    class << self
      # Creates a new +BitInt::Base+ subclass.
      #
      # Exactly one of +bits+ or +bytes+ must be supplied.
      #
      # An +ArgumentError+ is raised if the bit count isn't at least 1.
      #
      # === Example
      #   puts BitInt::Base.create(bits: 8, signed: true).new(128) #=> -127
      #   puts BitInt::Base.create(bytes: 1, signed: false).new(256) #=> 0
      def create(bits: nil, bytes: nil, signed:)
        if bits.nil? == bytes.nil?
          raise ArgumentError, 'exactly one of `bits` or `bytes` must be supplied'
        end

        bits ||= bytes * 8

        unless bits.positive?
          raise ArgumentError, 'bit count must be at least 1'
        end

        @classes[[bits, signed].freeze] ||= Class.new(Base) do |cls|
          cls.setup!(bits, signed)
        end
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
      # === Example
      #   puts BitInt::U8.signed? #=> false
      #   puts BitInt::I8.signed? #=> true
      def signed? = @signed

      # Returns whether this class represents an unsigned integer.
      #
      # === Example
      #   puts BitInt::U8.unsigned? #=> true
      #   puts BitInt::I8.unsigned? #=> false
      def unsigned? = !signed?

      # Returns a debugging string representation of this class
      #
      # If the class is one of the builtins (eg +BitInt::U16+), it uses its name
      # as the string, otherwise it uses a debugging representation
      #
      # === Example
      #    p BitInt::U16   #=> BitInt::U16
      #    p BitInt::U(17) #=> #<BitInt::Base @bits=17 @signed=false>
      def inspect = name || "#<BitInt::Base @bits=#@bits @signed=#@signed>"
      alias to_s inspect

      # "Mask"s an integer, making sure it fits within the bounds of this class.
      def mask(integer)
        ((integer - self::MIN.to_i) & self::MASK) + self::MIN.to_i
      end
    end

    # Creates a new BitInt by masking +integer+.
    #
    # If +integer+ is not rdoc-ref:in_bounds? and +wrap+ is false, then an
    # +OverflowError+ is raised.
    #
    # === Example
    #   puts BitInt::U8.new(27) #=> 27
    #   puts BitInt::U8.new(-1) #=> 255
    #   puts BitInt::U8.new(-1, wrap: false) #=> OverflowError
    #   puts BitInt::I8.new(255) #=> -1
    def initialize(integer, wrap: true)
      if !wrap && !self.class::BOUNDS.include?(integer)
        raise OverflowError.new(integer, self.class::BOUNDS)
      end

      @int = self.class.mask(integer)
      @wrap = wrap
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
    def ==(rhs) = defined?(rhs.to_i) && @int == rhs.to_i

    # Checks to see if +rhs+ is another +BitInt::Base+ of the same class, and
    # have the same contents.
    def eql?(rhs) = rhs.is_a?(self.class) && @int == rhs.to_i

    # Returns a hash code for this class.
    def hash = [self.class, @int].hash

    # Always return +true+, as +BitInt::Base+s are always integers.
    def integer? = true

    # :section: Conversions

    # Returns the underlying integer.
    def to_i = @int
    alias to_int to_i

    # Converts self to a Float.
    def to_f = @int.to_f

    # Converts self to a String.
    #
    # If no base is given, it just returns a normal string in base 10.
    # If a base is given, a string padded with `0`s will be returned.
    def to_s(base = nil)
      return @int.to_s if base.nil?

      adjusted = negative? ? (-2*self.class::MIN + self).to_i : @int
      adjusted.to_s(base).rjust(self.class::BITS / Math.log2(base), negative? ? '1' : '0')
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
      to_s(16).tap { _1.upcase! if upper }
    end

    # Returns a base-8 string of +self+. Equivalent to +to_s(8)+.
    #
    # === Example
    #   puts BitInt::U16.new(12345).oct #=> 30071
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

    private def new_instance(int) = self.class.new(int, wrap: @wrap)

    # :section: Math

    # Numerically negates +self+.
    def -@ = new_instance(-@int)

    # Bitwise negates +self+.
    def ~ = new_instance(~@int)

    # Compares +self+ to +rhs+.
    def <=>(rhs) = defined?(rhs.to_i) ? @int <=> (_ = rhs).to_i : nil

    # Adds +self+ to +rhs+.
    def +(rhs) = new_instance(@int + rhs.to_i)

    # Subtracts +rhs+ from +self+.
    def -(rhs) = new_instance(@int - rhs.to_i)

    # Multiplies +self+ by +rhs+.
    def *(rhs) = new_instance(@int * rhs.to_i)

    # Divides +self+ by +rhs+.
    def /(rhs) = new_instance(@int / rhs.to_i)

    # Modulos +self+ by +rhs+.
    def %(rhs) = new_instance(@int % rhs.to_i)

    # :section:

    # Returns whether +self+ is a positive integer. Zero is not positive.
    def positive? = @int.positive?

    # Return whether +self+ is a negative integer. Zero is not negative.
    def negative? = @int.negative?

    # Returns whether +self+ is zero.
    def zero? = @int.zero?

    # Returns a falsey value if zero, otherwise returns +self+.
    def nonzero? = @int.nonzero? && self

    # Checks to see if +self+ is even.
    def even? = @int.even?

    # Checks to see if +self+ is odd.
    def odd? = @int.odd?

    ##################################
    # :section: Bit-level operations #
    ##################################

    # Raises +self+ to the +rhs+th power.
    def **(rhs)
      # TODO: use `Integer#pow(int, int)`
      new_instance( (@int ** rhs.to_i).to_int ) # Numeric only defines `.to_int`
    end

    # Shifts +self+ left by +rhs+ bits.
    def <<(rhs) = new_instance(@int << rhs.to_i)

    # Shifts +self+ right by +rhs+ bits.
    def >>(rhs) = new_instance(@int >> rhs.to_i)

    # Bitwise ANDs +self+ and +rhs+.
    def &(rhs) = new_instance(@int & rhs.to_i)

    # Bitwise ORs +self+ and +rhs+.
    def |(rhs) = new_instance(@int | rhs.to_i)

    # Bitwise XORs +self+ and +rhs+.
    def ^(rhs) = new_instance(@int ^ rhs.to_i)

    # Gets the bit at index +idx+ or returns +nil+.
    #
    # This is equivalent to +Integer#[]+
    def [](idx) = @int[idx]

    # Returns true if any bit in `mask` is set in +self+.
    def anybits?(mask) = @int.anybits?(mask)

    # Returns true if all bits in `mask` are set in +self+.
    def allbits?(mask) = @int.allbits?(mask)

    # Returns true if no bits in `mask` are set in +self+.
    def nobits?(mask) = @int.nobits?(mask)

    # Returns the amount of bits required to represent +self+
    #
    # Unlike +Integer#bit_length+, this never changes and is equivalent
    # to +self.class::BITS+.
    def bit_length = self.class::BITS

    # Returns the amount of bytes required to represent +self+
    #
    # This is equivalent to +self.class::BYTES+
    def byte_length = self.class::BYTES

    def coerce(other) = [self, new_instance(other.to_i)]

    PACK_FMT = {
      [:native, 8,  false].freeze => 'C',
      [:native, 16, false].freeze => 'S',
      [:native, 32, false].freeze => 'L',
      [:native, 64, false].freeze => 'Q',
      [:native, 8,  true].freeze => 'c',
      [:native, 16, true].freeze => 's',
      [:native, 32, true].freeze => 'l',
      [:native, 64, true].freeze => 'q',

      [:little, 8,  false].freeze => 'C<',
      [:little, 16, false].freeze => 'S<',
      [:little, 32, false].freeze => 'L<',
      [:little, 64, false].freeze => 'Q<',
      [:little, 8,  true].freeze => 'c<',
      [:little, 16, true].freeze => 's<',
      [:little, 32, true].freeze => 'l<',
      [:little, 64, true].freeze => 'q<',

      [:big, 8,  false].freeze => 'C>',
      [:big, 16, false].freeze => 'S>',
      [:big, 32, false].freeze => 'L>',
      [:big, 64, false].freeze => 'Q>',
      [:big, 8,  true].freeze => 'c>',
      [:big, 16, true].freeze => 's>',
      [:big, 32, true].freeze => 'l>',
      [:big, 64, true].freeze => 'q>',
    }.freeze
    private_constant :PACK_FMT

    def bytes(endian = :native, &block)
      return to_enum(__method__, endian) unless block_given?

      base = @int
      byte_length.times do
        yield U8.new( base & 0xFF )
        base /= 0xFF
      end

      # template = '_CS_L___Q'[self.class::BYTES]
      # if template.nil? || template == '_'
      #   raise ArgumentError, 'bytes only works for sizes of 8, 16, 32, or 64.'
      # end

      # template.downcase! if self.class.signed?

      # case endian
      # when :native # do nothing
      # when :little then template.concat '<'
      # when :big    then template.concat '>'
      # else
      #   raise ArgumentError, 'endian must be :big, :little, or :native'
      # end

      fmt = PACK_FMT.fetch([ endian, self.class::BITS, self.class.signed? ]) {
        raise ArgumentError, "bytes only works for sizes of 8, 16, 32, or 64. and for :native, :little, or :big: #{[ endian, self.class::BYTES, self.class.signed? ]}"
      }

      [@int].pack(fmt)
        .unpack('C*')
        .map(&U8.method(:new))
        .each(&block)
    end

    def bytes_hex(...)
      bytes(...).map(&:hex)
    end
  end
end
