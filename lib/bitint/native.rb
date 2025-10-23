# frozen_string_literal: true
# rbs_inline: enabled

require 'fiddle'

module BitInt
  # +BitInt+s that correspond to underlying C integer sizes.
  module Native
    # On big-endian systems, the unpack will equal +0x00AA+.
    IS_LITTLE_ENDIAN = [0xAA00].pack('S').unpack('S<') == [0xAA00]
    private_constant :IS_LITTLE_ENDIAN

    module_function

    # Helper method to fetch the endianness of the underlying system.
    #
    # @rbs () -> (:little | :big)
    def endianness
      IS_LITTLE_ENDIAN ? :little : :big
    end

    class << self
      alias endian endianness
    end

    # Returns +true+ when on a little endian system.
    #
    # @rbs () -> bool
    def little_endian?
      endianness == :little
    end

    # Returns +true+ when on a big endian system.
    #
    # @rbs () -> bool
    def big_endian?
      endianness == :big
    end

    # @rbs!
    #   class SCHAR < Base end
    #   class UCHAR < Base end
    #   class SHORT < Base end
    #   class USHORT < Base end
    #   class INT < Base end
    #   class UINT < Base end
    #   class LONG < Base end
    #   class ULONG < Base end
    #   class LONG_LONG < Base end
    #   class ULONG_LONG < Base end
    #   class VOIDP < Base end
    #   class SIZE_T < Base end
    #   class SSIZE_T < Base end
    #   class PTRDIFF_T < Base end
    #   class INTPTR_T < Base end
    #   class UINTPTR_T < Base end

    # A signed +sizeof(char)+-byte BitInt.
    #
    # Technically C has a difference between +char+, +unsigned char+, and +signed char+. But there's
    # no real easy way to tell from within ruby code. So +CHAR+ doesn't exist.
    #
    # @rbs skip
    SCHAR = Base.create(bytes: Fiddle::SIZEOF_CHAR, signed: true)

    # An unsigned +sizeof(char)+-byte BitInt.
    #
    # @rbs skip
    UCHAR = Base.create(bytes: Fiddle::SIZEOF_CHAR, signed: false)

    # A signed +sizeof(short)+-byte BitInt.
    #
    # @rbs skip
    SHORT = Base.create(bytes: Fiddle::SIZEOF_SHORT, signed: true)

    # An unsigned +sizeof(short)+-byte BitInt.
    #
    # @rbs skip
    USHORT = Base.create(bytes: Fiddle::SIZEOF_SHORT, signed: false)

    # A signed +sizeof(int)+-byte BitInt.
    #
    # @rbs skip
    INT = Base.create(bytes: Fiddle::SIZEOF_INT, signed: true)

    # An unsigned +sizeof(int)+-byte BitInt.
    #
    # @rbs skip
    UINT = Base.create(bytes: Fiddle::SIZEOF_INT, signed: false)

    # A signed +sizeof(long)+-byte BitInt.
    #
    # @rbs skip
    LONG = Base.create(bytes: Fiddle::SIZEOF_LONG, signed: true)

    # An unsigned +sizeof(long)+-byte BitInt.
    #
    # @rbs skip
    ULONG = Base.create(bytes: Fiddle::SIZEOF_LONG, signed: false)

    # Some platforms Ruby supports don't actually support +long long+s (in this day and age...)
    if defined? Fiddle::SIZEOF_LONG_LONG
      # A signed +sizeof(long long)+-byte BitInt. Only enabled if the platform supports +long long+.
      #
      # @rbs skip
      LONG_LONG = Base.create(bytes: Fiddle::SIZEOF_LONG_LONG, signed: true)

      # An unsigned +sizeof(long long)+-byte BitInt. Only enabled if the platform supports +long long+.
      #
      # @rbs skip
      ULONG_LONG = Base.create(bytes: Fiddle::SIZEOF_LONG_LONG, signed: false)
    end

    # An unsigned +sizeof(void *)+-byte BitInt.
    #
    # @rbs skip
    VOIDP = Base.create(bytes: Fiddle::SIZEOF_VOIDP, signed: false)

    # An unsigned +sizeof(size_t)+-byte BitInt.
    #
    # @rbs skip
    SIZE_T = Base.create(bytes: Fiddle::SIZEOF_SIZE_T, signed: false)

    # A signed +sizeof(ssize_t)+-byte BitInt.
    #
    # @rbs skip
    SSIZE_T = Base.create(bytes: Fiddle::SIZEOF_SSIZE_T, signed: true)

    # A signed +sizeof(ptrdiff_t)+-byte BitInt.
    #
    # @rbs skip
    PTRDIFF_T = Base.create(bytes: Fiddle::SIZEOF_PTRDIFF_T, signed: true)

    # A signed +sizeof(intptr_t)+-byte BitInt.
    #
    # @rbs skip
    INTPTR_T = Base.create(bytes: Fiddle::SIZEOF_INTPTR_T, signed: true)

    # An unsigned +sizeof(uintptr_t)+-byte BitInt.
    #
    # @rbs skip
    UINTPTR_T = Base.create(bytes: Fiddle::SIZEOF_UINTPTR_T, signed: false)
  end
end
