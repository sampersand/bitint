# frozen_string_literal: true

class BitInt
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

    # Creates a new +BitInt+. Raises an ArgumentError if bits is negative.
    #
    # === Example
    #   puts BitInt[8]::MAX #=> 255
    #   puts BitInt[8, signed: false]::MAX #=> 255
    #   puts BitInt[8, signed: true]::MAX #=> 127
    def [](bits, signed: false)
      raise ArgumentError, "bit count must be positive" unless bits.positive?

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

  # Gets the bit at index +idx+ or returns +nil+.
  #
  # This is equivalent to +Integer#[]+
  def [](idx) = @int[idx]

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
    return @int.to_s(base).rjust(self.class::BITS / Math.log2(base), '0') if self.class.unsigned?

    fail "todo: signed result"
    # length = (self.class::BITS / Math.log2(base)).ceil
    # case base
    # when 2  then sprintf "%0#{length}b", @int
    # when 8  then sprintf "%0#{length}o", @int
    # when 16 then sprintf "%0#{length}x", @int
    # else
    # end
    # if @int.negative? 
    #   (self.class::MAX.to_i + @int + 1).to_s(base)
    # else
    #   (self.class::MAX.to_i + @int + 1).to_s(base)[1..]
    # end.then { _1.rjust self.class::BITS / Math.log2(base), @int.negative? ? '1' : '0' }
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
    fmt = "%0#{(self.class::BITS / 4)}#{upper ? 'X' : 'x'}"
    sprintf(fmt, self)[-self.class::BITS.fdiv(4).floor ..]
  end

  # Returns a base-8 string of +self+. Equivalent to +to_s(8)+.
  #
  # === Example
  #   puts BitInt::U16.new(1234).oct #=> 02322
  def oct
    fmt = "%0#{(self.class::BITS / 8)}o"
    sprintf(fmt, self)#[-self.class::BITS.fdiv(4).floor ..]
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

  def positive? = @int.positive?
  def negative? = @int.negative?
  def zero? = @int.zero?
  def nonzero? = @int.nonzero? && self
end

class BitInt
  def to_s(base = nil)
    return @int.to_s if base.nil?
    return @int.to_s(base).rjust(self.class::BITS / Math.log2(base), '0') if self.class.unsigned?

    unless negative?
      return @int.to_s(base).rjust (self.class::BITS / Math.log2(base)).ceil, '0'
    end

    # ((self.class::MAX.to_i + 1 + @int) | (1 << self.class::BITS.pred)).to_s(base)
    ((~self.class::MIN.to_i + @int) - self.class::MIN.to_i)
      .to_s(base)
      .rjust((self.class::BITS / Math.log2(base)).ceil, '0')
    # (self.class::MAX.to_i + @int + 1)
    # length = (self.class::BITS / Math.log2(base)).ceil
    # case base
    # when 2  then sprintf "%0#{length}b", @int
    # when 8  then sprintf "%0#{length}o", @int
    # when 16 then sprintf "%0#{length}x", @int
    # else
    # end
    # if @int.negative? 
    #   (self.class::MAX.to_i + @int + 1).to_s(base)
    # else
    #   (self.class::MAX.to_i + @int + 1).to_s(base)[1..]
    # end.then { _1.rjust self.class::BITS / Math.log2(base), @int.negative? ? '1' : '0' }
  end
end

(-128...0).each do

  puts BitInt::I(8).new(_1).bin
  puts BitInt::I(8)::MIN.bin
  puts BitInt::I(8).new(_1-1).bin
  # fail "#{_1}" unless ("1%07b" % _1) == BitInt::I(8).new(_1).bin
  exit
end
__END__

p BitInt::I(8)::MAX.to_s(2)
p BitInt::I(8)::MAX.to_s(2)
p BitInt::I(8)::new(-2).to_s(2)
p BitInt::I(8)::new(-3).to_s(2)
p BitInt::I(8)::MIN.to_s(2)
__END__
# puts BitInt[16, signed: true]::MIN.hex
# puts BitInt[16, signed: true]::MAX.hex

# puts BitInt[29, signed: true]::MIN.hex
puts BitInt[8, signed: true]::MAX.oct
puts BitInt[8, signed: true]::MIN.oct
# puts BitInt[29, signed: true]::MAX.oct

