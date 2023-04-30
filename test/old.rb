__END__
# frozen_string_literal: true
$: << '.' if $0 == __FILE__
require 'test_helper'

describe BitInt do
  class Minitest::Expectation
    def must_equal_kind(value, kind)
        must_equal value
        must_be_kind_of kind
    end
  end

  describe 'the U8 constant' do
    subject { BitInt::U8 }

    it 'is equivalent to BitInt::BitInt::U(8)' do
      value(subject).must_equal BitInt::BitInt::U(8)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 8, Integer
      value(subject::MAX).must_equal_kind 0xFF, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

  describe 'the U16 constant' do
    subject { BitInt::U16 }

    it 'is equivalent to BitInt::BitInt::U(16)' do
      value(subject).must_equal BitInt::BitInt::U(16)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 16, Integer
      value(subject::MAX).must_equal_kind 0xFFFF, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x0000, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

  describe 'the U32 constant' do
    subject { BitInt::U32 }

    it 'is equivalent to BitInt::BitInt::U(32)' do
      value(subject).must_equal BitInt::BitInt::U(32)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 32, Integer
      value(subject::MAX).must_equal_kind 0xFFFFFFFF, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00000000, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

  describe 'the U64 constant' do
    subject { BitInt::U64 }

    it 'is equivalent to BitInt::BitInt::U(64)' do
      value(subject).must_equal BitInt::BitInt::U(64)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 64, Integer
      value(subject::MAX).must_equal_kind 0xFFFFFFFF_FFFFFFFF, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00000000_00000000, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end


  describe 'the U128 constant' do
    subject { BitInt::U128 }

    it 'is equivalent to BitInt::BitInt::U(128)' do
      value(subject).must_equal BitInt::BitInt::U(128)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 128, Integer
      value(subject::MAX).must_equal_kind 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00000000_00000000_00000000_00000000, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

=begin
  describe 'the U8 constant' do
    subject { BitInt::U8 }

    it 'is equivalent to BitInt::BitInt::U(8)' do
      value(subject).must_equal BitInt::BitInt::U(8)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 8, Integer
      value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

  describe 'the U8 constant' do
    subject { BitInt::U8 }

    it 'is equivalent to BitInt::BitInt::U(8)' do
      value(subject).must_equal BitInt::BitInt::U(8)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 8, Integer
      value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

  describe 'the U8 constant' do
    subject { BitInt::U8 }

    it 'is equivalent to BitInt::BitInt::U(8)' do
      value(subject).must_equal BitInt::BitInt::U(8)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 8, Integer
      value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end

  describe 'the U8 constant' do
    subject { BitInt::U8 }

    it 'is equivalent to BitInt::BitInt::U(8)' do
      value(subject).must_equal BitInt::BitInt::U(8)
    end

    it 'must have MIN, MAX, and BOUNDS defined' do
      value(subject::BITS).must_equal_kind 8, Integer
      value(subject::MAX).must_equal_kind 0xff, BitInt::BitInt
      value(subject::MIN).must_equal_kind 0x00, BitInt::BitInt
      value(subject::ZERO).must_equal_kind 0, BitInt::BitInt
      value(subject::ONE).must_equal_kind 1, BitInt::BitInt
      value(subject::BOUNDS).must_equal subject::MIN .. subject::MAX
    end
  end
=end
end
