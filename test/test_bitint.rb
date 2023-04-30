# frozen_string_literal: true

require "test_helper"

describe BitInt do
  it 'has a version' do
    value(BitInt::VERSION).must_be_kind_of String
  end
end
