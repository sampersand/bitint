# frozen_string_literal: true

class BitInt < Numeric
  # Indicates that +BitInt::new+ was called with an integer that was too large.
  class OverflowError < RuntimeError
    attr_reader :integer, :range

    def initialize(integer, range)
      super "#{integer} is out of bounds (range=#{range})"
      @integer = integer
      @range = range
    end
  end

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
    alias S I

    # Creates a new +BitInt+. Raises an ArgumentError if bits is negative.
    #
    # === Example
    #   puts BitInt[8]::MAX #=> 255
    #   puts BitInt[8, signed: false]::MAX #=> 255
    #   puts BitInt[8, signed: true]::MAX #=> 127
    def [](bits, signed: false) = create(bits: bits, signed: signed)

    def create(bits: nil, bytes: nil, signed:)
      if bits.nil? == bytes.nil?
        raise ArgumentError, 'exactly one of `bits` or `bytes` must be supplied'
      end

      bits ||= bytes * 8

      raise ArgumentError, 'bit count must be at least 1' unless bits.positive?

      @classes[[bits, signed].freeze] ||= Class.new(self) do |cls|
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

    def pack_char

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
    unless wrap || (bounds = self.class::BOUNDS).include?(int)
      raise OverflowError.new(int, bounds)
    end

    @int = ((int - self.class::MIN.to_i) & self.class::MASK) + self.class::MIN.to_i
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
  def ==(rhs) = rhs.respond_to?(:to_i) && @int == rhs.to_i

  # Overwite rdoc-ref:Numeric#integer? as we're an integer.
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
  def -@ = self.class.new(-@int)

  # Bitwise negates +self+.
  def ~ = self.class.new(~@int)

  # Compares +self+ to +rhs+.
  def <=>(rhs) = rhs.respond_to?(:to_i) ? @int <=> (_ = rhs).to_i : nil

  # Adds +self+ to +rhs+.
  def +(rhs) = self.class.new(@int + rhs.to_i)

  # Subtracts +rhs+ from +self+.
  def -(rhs) = self.class.new(@int - rhs.to_i)

  # Multiplies +self+ by +rhs+.
  def *(rhs) = self.class.new(@int * rhs.to_i)

  # Divides +self+ by +rhs+.
  def /(rhs) = self.class.new(@int / rhs.to_i)

  # Modulos +self+ by +rhs+.
  def %(rhs) = self.class.new(@int % rhs.to_i)

  # Raises +self+ to the +rhs+th power.
  # Note that `Numeric` only defines `.to_int` (not `.to_i`)
  def **(rhs) = self.class.new((@int ** rhs.to_i).to_int)

  # Shifts +self+ left by +rhs+ bits.
  def <<(rhs) = self.class.new(@int << rhs.to_i)

  # Shifts +self+ right by +rhs+ bits.
  def >>(rhs) = self.class.new(@int >> rhs.to_i)

  # Bitwise ANDs +self+ and +rhs+.
  def &(rhs) = self.class.new(@int & rhs.to_i)

  # Bitwise ORs +self+ and +rhs+.
  def |(rhs) = self.class.new(@int | rhs.to_i)

  # Bitwise XORs +self+ and +rhs+.
  def ^(rhs) = self.class.new(@int ^ rhs.to_i)

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

  # Gets the bit at index +idx+ or returns +nil+.
  #
  # This is equivalent to +Integer#[]+
  def [](idx) = @int[idx]

  def anybits?(mask) = @int.anybits?(mask)
  def allbits?(mask) = @int.allbits?(mask)
  def nobits?(mask) = @int.nobits?(mask)
  def bit_length = @int.bit_length

  def size = (self.class::BITS / 8.0).ceil


  PACK_FMT = {
    [:native, 8,  false].freeze => 'C',
    [:native, 16, false].freeze => 'S',
    [:native, 32, false].freeze => 'L',
    [:native, 64, false].freeze => 'Q',
    [:native, 8,  true].freeze => 'c',
    [:native, 16, true].freeze => 's',
    [:native, 32, true].freeze => 'l',
    [:native, 64, true].freeze => 'q',

  }.freeze
  private_constant :PACK_FMT

  def bytes(endian = :native)
    size = {
      8 => 'C',
      16 => 'S',
      32 => 'L',
      64 => 'Q'
    }[self.class::BITS] or raise ArgumentError, "bytes only works for 8, 16, 32, or 64 rn." or raise ArgumentError, "endian must be :big, :little, or :native"
    size = {8=>'C', 16=>}
    size = case self.class::BITS
           when 8 then 'C'
           when 8 then 'C'
    # sprintf "%0#{self.class::BYTES * 2}x",
    # mask = self.class::MASK_CHAR or raise ArgumentError, "bytes only works (rn) on "
    # pack_char = self.class.pack_Char
    # case endian
    # when :native then 
  end
end


(-128..127).each do |n|
  puts (BitInt::I(8).new(n)).to_s(2)
end
