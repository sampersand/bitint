module BitInt
  module_function

  class << self
    def unsigned(bits) = 32
    alias U unsigned
end

p BitInt.U 3

__END__
  class << self
    def unsigned(bits) self[bits, signed: false] end
    alias U unsigned

    def signed(bits) self[bits, signed: true] end
    alias I signed

    def [](bits, signed: false)
      Class.new(self) do |cls|
        cls.setup!(bits, signed)
      end
    end

