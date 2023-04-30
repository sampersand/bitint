# frozen_string_literal: true
require 'test_helper'

describe BitInt do
  it 'has unsigned constants' do
    value(BitInt::U8).must_equal BitInt::BitInt::U(8)
    value(BitInt::U16).must_equal BitInt::BitInt::U(16)
    value(BitInt::U32).must_equal BitInt::BitInt::U(32)
    value(BitInt::U64).must_equal BitInt::BitInt::U(64)
    value(BitInt::U128).must_equal BitInt::BitInt::U(128)
  end

  it 'has signed constants' do
    value(BitInt::I8).must_equal BitInt::BitInt::I(8)
    value(BitInt::I16).must_equal BitInt::BitInt::I(16)
    value(BitInt::I32).must_equal BitInt::BitInt::I(32)
    value(BitInt::I64).must_equal BitInt::BitInt::I(64)
    value(BitInt::I128).must_equal BitInt::BitInt::I(128)
  end
end
