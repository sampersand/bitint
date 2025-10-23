# frozen_string_literal: true
# rbs_inline: enabled

# @rbs!
#   module BitInt
#     class U8 < Base end
#     class U16 < Base end
#     class U32 < Base end
#     class U64 < Base end
#     class U128 < Base end
#     class I8 < Base end
#     class I16 < Base end
#     class I32 < Base end
#     class I64 < Base end
#     class I128 < Base end
#   end

# @rbs skip
module BitInt
  # An unsigned 8-bit integer
  U8 = U(8)

  # An unsigned 16-bit integer
  U16 = U(16)

  # An unsigned 32-bit integer
  U32 = U(32)

  # An unsigned 64-bit integer
  U64 = U(64)

  # An unsigned 128-bit integer
  U128 = U(128)

  # A signed 8-bit integer
  I8 = I(8)

  # A signed 16-bit integer
  I16 = I(16)

  # A signed 32-bit integer
  I32 = I(32)

  # A signed 64-bit integer
  I64 = I(64)

  # A signed 128-bit integer
  I128 = I(128)
end
