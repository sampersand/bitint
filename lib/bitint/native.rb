# frozen_string_literal: true

require 'fiddle'

class BitInt
  # `BitInt`s that correspond to underlying C integer sizes.
  module Native
    # On big-endian systems, the unpack will equal `0x00AA`.
    IS_LITTLE_ENDIAN = [0xAA00].pack('S').unpack('S<') == [0xAA00]
    private_constant :IS_LITTLE_ENDIAN

    module_function

    # Returns either `:little` or `:big` depending on the underlying system's endianness.
    def endianness
      @IS_LITTLE_ENDIAN ? :little : :big
    end

    class << self
      alias endian endianness
    end

    # Returns `true` when on a little endian system.
    def little_endian?
      endianness == :little
    end

    # Returns `true` when on a big endian system.
    def big_endian?
      endianness == :big
    end

    # A signed `sizeof(char)`-byte BitInt.
    #
    # Technically C has a difference between `char`, `unsigned char`, and `signed char`. But there's
    # no real easy way to tell from within ruby code. So `CHAR` doesn't exist.
    #
    SCHAR = BitInt.create(bytes: Fiddle::SIZEOF_CHAR, signed: true)

    # An unsigned `sizeof(char)`-byte BitInt.
    UCHAR = BitInt.create(bytes: Fiddle::SIZEOF_CHAR, signed: false)

    # A signed `sizeof(short)`-byte BitInt.
    SHORT = BitInt.create(bytes: Fiddle::SIZEOF_SHORT, signed: true)

    # An unsigned `sizeof(short)`-byte BitInt.
    USHORT = BitInt.create(bytes: Fiddle::SIZEOF_SHORT, signed: false)

    # A signed `sizeof(int)`-byte BitInt.
    INT = BitInt.create(bytes: Fiddle::SIZEOF_INT, signed: true)

    # An unsigned `sizeof(short)`-byte BitInt.
    UINT = BitInt.create(bytes: Fiddle::SIZEOF_INT, signed: false)

    # A signed `sizeof(long)`-byte BitInt.
    LONG = BitInt.create(bytes: Fiddle::SIZEOF_LONG, signed: true)

    # An unsigned `sizeof(short)`-byte BitInt.
    ULONG = BitInt.create(bytes: Fiddle::SIZEOF_LONG, signed: false)

    # Some platforms Ruby supports don't actually support `long long`s (in this day and age...)
    if defined? Fiddle::SIZEOF_LONG_LONG
      # A signed `sizeof(long long)`-byte BitInt. Only enabled if the platform supports `long long`.
      LONG_LONG = BitInt.create(bytes: Fiddle::SIZEOF_LONG_LONG, signed: true)

      # An unsigned `sizeof(long long)`-byte BitInt. Only enabled if the platform supports `long long`.
      ULONG_LONG = BitInt.create(bytes: Fiddle::SIZEOF_LONG_LONG, signed: false)
    end

    # An unsigned `sizeof(void *)`-byte BitInt.
    VOIDP = BitInt.create(bytes: Fiddle::SIZEOF_VOIDP, signed: false)

    # An unsigned `sizeof(size_t)`-byte BitInt.
    SIZE_T = BitInt.create(bytes: Fiddle::SIZEOF_SIZE_T, signed: false)

    # A signed `sizeof(ssize_t)`-byte BitInt.
    SSIZE_T = BitInt.create(bytes: Fiddle::SIZEOF_SSIZE_T, signed: true)

    # A signed `sizeof(ptrdiff_t)`-byte BitInt.
    PTRDIFF_T = BitInt.create(bytes: Fiddle::SIZEOF_PTRDIFF_T, signed: true)

    # A signed `sizeof(intptr_t)`-byte BitInt.
    INTPTR_T = BitInt.create(bytes: Fiddle::SIZEOF_INTPTR_T, signed: true)

    # An unsigned `sizeof(uintptr_t)`-byte BitInt.
    UINTPTR_T = BitInt.create(bytes: Fiddle::SIZEOF_UINTPTR_T, signed: false)
  end
end
