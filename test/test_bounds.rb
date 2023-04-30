# frozen_string_literal: true
require 'test_helper'

describe BitInt do
  let(:u8) { BitInt::U(8) }
  let(:u16) { BitInt::U(16) }
  let(:u32) { BitInt::U(32) }
  let(:u64) { BitInt::U(64) }
  let(:u128) { BitInt::U(128) }
  let(:i8) { BitInt::I(8) }
  let(:i16) { BitInt::I(16) }
  let(:i32) { BitInt::I(32) }
  let(:i64) { BitInt::I(64) }
  let(:i128) { BitInt::I(128) }

  describe 'bounds' do
    def assert_equal_and_kind(expected, actual, cls)
      assert_equal(expected, actual)
      assert_kind_of(cls, actual)
    end

    def assert_equal_and_bitint(expected, actual)
      assert_equal_and_kind(expected, actual, actual.class)
    end

    it 'has BITS defined' do
      assert_equal_and_kind 8, u8::BITS, Integer
      assert_equal_and_kind 16, u16::BITS, Integer
      assert_equal_and_kind 32, u32::BITS, Integer
      assert_equal_and_kind 64, u64::BITS, Integer
      assert_equal_and_kind 128, u128::BITS, Integer

      assert_equal_and_kind 8, i8::BITS, Integer
      assert_equal_and_kind 16, i16::BITS, Integer
      assert_equal_and_kind 32, i32::BITS, Integer
      assert_equal_and_kind 64, i64::BITS, Integer
      assert_equal_and_kind 128, i128::BITS, Integer
    end

    it 'has MAX defined' do
      assert_equal_and_bitint 0xFF, u8::MAX
      assert_equal_and_bitint 0xFFFF, u16::MAX
      assert_equal_and_bitint 0xFFFFFFFF, u32::MAX
      assert_equal_and_bitint 0xFFFFFFFFFFFFFFFF, u64::MAX
      assert_equal_and_bitint 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, u128::MAX

      assert_equal_and_bitint 0x7F, i8::MAX
      assert_equal_and_bitint 0x7FFF, i16::MAX
      assert_equal_and_bitint 0x7FFFFFFF, i32::MAX
      assert_equal_and_bitint 0x7FFFFFFFFFFFFFFF, i64::MAX
      assert_equal_and_bitint 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, i128::MAX
    end

    it 'has MIN defined' do
      assert_equal_and_bitint 0, u8::MIN
      assert_equal_and_bitint 0, u16::MIN
      assert_equal_and_bitint 0, u32::MIN
      assert_equal_and_bitint 0, u64::MIN
      assert_equal_and_bitint 0, u128::MIN

      assert_equal_and_bitint(-0x80, i8::MIN)
      assert_equal_and_bitint(-0x8000, i16::MIN)
      assert_equal_and_bitint(-0x80000000, i32::MIN)
      assert_equal_and_bitint(-0x8000000000000000, i64::MIN)
      assert_equal_and_bitint(-0x80000000000000000000000000000000, i128::MIN)
    end

    it 'has ZERO defined' do
      assert_equal_and_bitint 0, u8::ZERO
      assert_equal_and_bitint 0, u16::ZERO
      assert_equal_and_bitint 0, u32::ZERO
      assert_equal_and_bitint 0, u64::ZERO
      assert_equal_and_bitint 0, u128::ZERO

      assert_equal_and_bitint 0, i8::ZERO
      assert_equal_and_bitint 0, i16::ZERO
      assert_equal_and_bitint 0, i32::ZERO
      assert_equal_and_bitint 0, i64::ZERO
      assert_equal_and_bitint 0, i128::ZERO
    end

    it 'has ONE defined' do
      assert_equal_and_bitint 1, u8::ONE
      assert_equal_and_bitint 1, u16::ONE
      assert_equal_and_bitint 1, u32::ONE
      assert_equal_and_bitint 1, u64::ONE
      assert_equal_and_bitint 1, u128::ONE

      assert_equal_and_bitint 1, i8::ONE
      assert_equal_and_bitint 1, i16::ONE
      assert_equal_and_bitint 1, i32::ONE
      assert_equal_and_bitint 1, i64::ONE
      assert_equal_and_bitint 1, i128::ONE
    end

    it 'has BOUNDS defined' do
      assert_equal u8::MIN .. u8::MAX, u8::BOUNDS
      assert_equal u16::MIN .. u16::MAX, u16::BOUNDS
      assert_equal u32::MIN .. u32::MAX, u32::BOUNDS
      assert_equal u64::MIN .. u64::MAX, u64::BOUNDS
      assert_equal u128::MIN .. u128::MAX, u128::BOUNDS

      assert_equal i8::MIN .. i8::MAX, i8::BOUNDS
      assert_equal i16::MIN .. i16::MAX, i16::BOUNDS
      assert_equal i32::MIN .. i32::MAX, i32::BOUNDS
      assert_equal i64::MIN .. i64::MAX, i64::BOUNDS
      assert_equal i128::MIN .. i128::MAX, i128::BOUNDS
    end
  end

  describe '[]' do
  end

  describe 'U' do
  end

  describe 'I' do
  end

  describe 'signed?' do
    it 'responds false for unsigned' do
      value(u8).wont_be :signed?
      value(u128).wont_be :signed?
    end

    it 'responds true for signed' do
      value(i8).must_be :signed?
      value(i128).must_be :signed?
    end
  end

  describe 'unsigned?' do
    it 'responds true for unsigned' do
      value(u8).must_be :unsigned?
      value(u128).must_be :unsigned?
    end

    it 'responds false for signed' do
      value(i8).wont_be :unsigned?
      value(i128).wont_be :unsigned?
    end
  end

  describe 'inspect / to_s' do
  end

  describe 'new' do
  end

  describe 'BitInt#==' do
    class DummyInt; def to_i = 12 end
    class DummyNotInt; end

    it 'converts to_i and has ints' do
      twelve = u8.new 12

      value(twelve).must_be :==, DummyInt.new
      value(twelve).wont_be :==, DummyNotInt.new
      value(twelve).must_be :==, 12
      value(twelve).wont_be :==, 13
      value(twelve).must_be :==, twelve
      value(twelve).wont_be :==, u8.new(13)
      value(twelve).must_be :==, i8.new(12)

      value(twelve).wont_be :==, i8.new(-12)
      # TODO: check for wraparounds
    end
  end

  describe 'BitInt#integer?' do
    it 'is an integer' do
      value(u8::ZERO).must_be :integer?
      value(i8::ZERO).must_be :integer?
      value(u128::ZERO).must_be :integer?
      value(i128::ZERO).must_be :integer?
    end
  end

  describe 'BitInt#[]' do
  end

  describe 'BitInt#to_i / to_int' do
    it 'returns the internal integer' do
      value(u8.new(12).to_i).must_equal 12
      value(u8.new(123).to_i).must_equal 123
      value(i8.new(-123).to_i).must_equal(-123)
    end

    it 'also responds to to_int' do
      value(u8.new(12).to_int).must_equal 12
      value(u8.new(123).to_int).must_equal 123
      value(i8.new(-123).to_int).must_equal(-123)
    end
  end

  describe 'BitInt#to_f' do
    it 'returns the internal integer converted to a float' do
      value(u8.new(12).to_f).must_be_within_epsilon 12.0
      value(u8.new(123).to_f).must_be_within_epsilon 123.0
      value(i8.new(-123).to_i).must_be_within_epsilon(-123.0)
    end
  end

  describe 'BitInt#to_s' do
  end

=begin
  describe 'BitInt#hex' do
    # no need to test further since to_s does.
    it 'returns hexadecimal integers'do
      value(u8::MAX.hex).must_equal 'ff'
      value(i16::MIN.hex).must_equal '8000'
    end
  end

  describe 'BitInt#oct' do
    # no need to test further since to_s does.
    it 'returns hexadecimal integers'do
      value(u8::MAX.oct).must_equal '377'
      value(i16::MIN.oct).must_equal '100000'
    end
  end

  describe 'BitInt#bin' do
    # no need to test further since to_s does.
    it 'returns hexadecimal integers'do
      value(u8::MAX.bin).must_equal '11111111'
      value(i16::MIN.bin).must_equal '1000000000000000'
    end
  end
=end

  describe '-@' do
    it 'negates normal signed integers' do
      value(-i16.new(12)).must_equal(-12)
      value(-i32.new(-12)).must_equal(12)
    end

    it 'handles the bounds properly' do
      value(-i16::MIN).must_equal i16::MIN
      value(-i128::MIN).must_equal i128::MIN

      value(-i16::MAX).must_equal i16::MIN + 1
      value(-i128::MAX).must_equal i128::MIN + 1
    end

    it 'negates unsigned numbers' do
      value(-u16::MAX).must_equal 1
      value(-u32.new(10)).must_equal 4294967286
    end
  end

  describe '~' do
    it 'inverts integers on unsigned correctly' do
      value(~u8.new(0b0000_1101)).must_equal 0b1111_0010
      value(~u128::MIN).must_equal u128::MAX
      value(~u64::MAX).must_equal u64::MIN
    end

    it 'is -x-1 for normal signed integers' do
      value(~i8.new(-12)).must_equal 11
      value(~i32.new(65537)).must_equal(-65538)
    end

    it 'handles the bounds properly' do
      value(~i8::MAX).must_equal i8::MIN
      value(~i128::MIN).must_equal i128::MAX
    end
  end

=begin

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

=end
end
