#
# byte manipulation
# TODO look not used, removed
#
class DrModByte
  def initialize octal
    @octal = octal
  end

  def first_byte
    @octal & 0xF0
  end

  def second_byte
    @octal & 0xF0
  end

end
