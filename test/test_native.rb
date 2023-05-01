require 'test_helper'

describe BitInt::Native do
  describe 'endianness' do
    it 'has @little_endian already set' do
      assert_includes %i[little big], BitInt::Native.endianness
      assert_includes [true, false], BitInt::Native.big_endian?
      assert_equal !BitInt::Native.big_endian?, BitInt::Native.little_endian?
    end

    describe 'big endian' do
      before do
        @was_little_endian = BitInt::Native.instance_variable_get(:@little_endian)
        BitInt::Native.instance_variable_set(:@little_endian, false)
      end

      after do
        BitInt::Native.instance_variable_set(:@little_endian, @was_little_endian)
      end

      it 'is big endian' do
        assert_equal :big, BitInt::Native.endianness
        assert_equal :big, BitInt::Native.endian
        assert BitInt::Native.big_endian?
        refute BitInt::Native.little_endian?
      end
    end

    describe 'little endian' do
      before do
        @was_little_endian = BitInt::Native.instance_variable_get(:@little_endian)
        BitInt::Native.instance_variable_set(:@little_endian, true)
      end

      after do
        BitInt::Native.instance_variable_set(:@little_endian, @was_little_endian)
      end

      it 'is little endian' do
        assert_equal :little, BitInt::Native.endianness
        assert_equal :little, BitInt::Native.endian
        refute BitInt::Native.big_endian?
        assert BitInt::Native.little_endian?
      end
    end
  end

  describe 'the constants' do
    def assert_size_signedness(byte_length, is_signed, constant)
      assert_equal byte_length * 8, constant::BITS
      assert_equal is_signed, constant.signed?
    end

    it 'has the normal signed types' do
      assert_size_signedness Fiddle::SIZEOF_CHAR, true, BitInt::Native::SCHAR
      assert_size_signedness Fiddle::SIZEOF_SHORT, true, BitInt::Native::SHORT
      assert_size_signedness Fiddle::SIZEOF_INT, true, BitInt::Native::INT
      assert_size_signedness Fiddle::SIZEOF_LONG, true, BitInt::Native::LONG

      if defined? Fiddle::SIZEOF_LONG_LONG
        assert_size_signedness Fiddle::SIZEOF_LONG_LONG, true, BitInt::Native::LONG_LONG
      end
    end

    it 'has the normal unsigned types' do
      assert_size_signedness Fiddle::SIZEOF_CHAR, false, BitInt::Native::UCHAR
      assert_size_signedness Fiddle::SIZEOF_SHORT, false, BitInt::Native::USHORT
      assert_size_signedness Fiddle::SIZEOF_INT, false, BitInt::Native::UINT
      assert_size_signedness Fiddle::SIZEOF_LONG, false, BitInt::Native::ULONG

      if defined? Fiddle::SIZEOF_LONG_LONG
        assert_size_signedness Fiddle::SIZEOF_LONG_LONG, false, BitInt::Native::ULONG_LONG
      end
    end

    it 'has additional types' do
      assert_size_signedness Fiddle::SIZEOF_VOIDP, false, BitInt::Native::VOIDP
      assert_size_signedness Fiddle::SIZEOF_SIZE_T, false, BitInt::Native::SIZE_T
      assert_size_signedness Fiddle::SIZEOF_SSIZE_T, true, BitInt::Native::SSIZE_T
      assert_size_signedness Fiddle::SIZEOF_PTRDIFF_T, true, BitInt::Native::PTRDIFF_T
      assert_size_signedness Fiddle::SIZEOF_INTPTR_T, true, BitInt::Native::INTPTR_T
      assert_size_signedness Fiddle::SIZEOF_UINTPTR_T, false, BitInt::Native::UINTPTR_T
    end
  end
end
