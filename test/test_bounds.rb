# frozen_string_literal: true
$: << '.' if $0 == __FILE__
require 'test_helper'

describe BitInt do
  let(:u8) { BitInt::BitInt::U(8) }
  let(:u16) { BitInt::BitInt::U(16) }
  let(:u32) { BitInt::BitInt::U(32) }
  let(:u64) { BitInt::BitInt::U(64) }
  let(:u128) { BitInt::BitInt::U(128) }
  let(:i8) { BitInt::BitInt::I(8) }
  let(:i16) { BitInt::BitInt::I(16) }
  let(:i32) { BitInt::BitInt::I(32) }
  let(:i64) { BitInt::BitInt::I(64) }
  let(:i128) { BitInt::BitInt::I(128) }

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

      assert_equal_and_bitint -0x80, i8::MIN
      assert_equal_and_bitint -0x8000, i16::MIN
      assert_equal_and_bitint -0x80000000, i32::MIN
      assert_equal_and_bitint -0x8000000000000000, i64::MIN
      assert_equal_and_bitint -0x80000000000000000000000000000000, i128::MIN
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

  describe 'BitInt::[]' do
  end

  describe 'BitInt::U' do
  end

  describe 'BitInt::I' do
  end

  describe 'BitInt::signed?' do
    value(u8).must_be :signed?
    value(u128).must_be :signed?

    value(i8).wont_be :signed?
    value(u128).wont_be :signed?
  end

  describe 'BitInt::unsigned?' do
    value(u8).wont_be :signed?
    value(i8).must_be :signed?
    value(u128).wont_be :signed?
    value(u128).must_be :signed?
  end

  describe 'BitInt::inspect / BitInt::to_s' do
  end

  describe 'BitInt::new' do
  end

  describe 'BitInt#==' do
    class DummyInt; def to_i = 12 end
    class DummyNotInt; end

    it 'converts to_i and has ints' do
      value(u8.new(12)).must_be_equal DummyInt.new
      value(u8.new(12)).must_not_equal DummyNotInt.new
      value(u8.new(12)).must_equal 12
      value(u8.new(12)).must_equal u8.new(12)
    end
  end

  describe 'BitInt#integer?' do
    it 'is an integer' do
      value(u8).must_be :integer?
      value(i8).must_be :integer?
      value(u128).must_be :integer?
      value(i128).must_be :integer?
    end
  end

  describe 'BitInt#[]' do
  end

  describe 'BitInt#to_i / to_int' do
  end

  describe 'BitInt#to_f' do
  end

  describe 'BitInt#to_s' do
  end

  describe 'BitInt#hex' do
  end
end


__END__
#   describe 'the unsigned 8 bit integer constant' do
#     subject { BitInt::U8 }

#     it 'is equivalent to BitInt::BitInt::U(8)' do
#       value(subject).must_equal BitInt::BitInt::U(8)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 8, Integer
#       value(subject::MAX).must_equal_kind 0xFF, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

#   describe 'the U16 constant' do
#     subject { BitInt::U16 }

#     it 'is equivalent to BitInt::BitInt::U(16)' do
#       value(subject).must_equal BitInt::BitInt::U(16)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 16, Integer
#       value(subject::MAX).must_equal_kind 0xFFFF, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x0000, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

#   describe 'the U32 constant' do
#     subject { BitInt::U32 }

#     it 'is equivalent to BitInt::BitInt::U(32)' do
#       value(subject).must_equal BitInt::BitInt::U(32)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 32, Integer
#       value(subject::MAX).must_equal_kind 0xFFFFFFFF, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00000000, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

#   describe 'the U64 constant' do
#     subject { BitInt::U64 }

#     it 'is equivalent to BitInt::BitInt::U(64)' do
#       value(subject).must_equal BitInt::BitInt::U(64)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 64, Integer
#       value(subject::MAX).must_equal_kind 0xFFFFFFFF_FFFFFFFF, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00000000_00000000, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end


#   describe 'the U128 constant' do
#     subject { BitInt::U128 }

#     it 'is equivalent to BitInt::BitInt::U(128)' do
#       value(subject).must_equal BitInt::BitInt::U(128)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 128, Integer
#       value(subject::MAX).must_equal_kind 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00000000_00000000_00000000_00000000, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

# =begin
#   describe 'the U8 constant' do
#     subject { BitInt::U8 }

#     it 'is equivalent to BitInt::BitInt::U(8)' do
#       value(subject).must_equal BitInt::BitInt::U(8)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 8, Integer
#       value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

#   describe 'the U8 constant' do
#     subject { BitInt::U8 }

#     it 'is equivalent to BitInt::BitInt::U(8)' do
#       value(subject).must_equal BitInt::BitInt::U(8)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 8, Integer
#       value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

#   describe 'the U8 constant' do
#     subject { BitInt::U8 }

#     it 'is equivalent to BitInt::BitInt::U(8)' do
#       value(subject).must_equal BitInt::BitInt::U(8)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 8, Integer
#       value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end

#   describe 'the U8 constant' do
#     subject { BitInt::U8 }

#     it 'is equivalent to BitInt::BitInt::U(8)' do
#       value(subject).must_equal BitInt::BitInt::U(8)
#     end

#     it 'must have MIN, MAX, and BOUNDS defined' do
#       value(subject::BITS).must_equal_kind 8, Integer
#       value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
#       value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
#       value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
#       value(subject::ONE).must_equal_kind 1, BitInt::BitInt
#       value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
#     end
#   end
# =end
end
