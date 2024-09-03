#
# tool for byte
#
module LoadTool

  T_SPEC = PROTRACKER_1_1_B

  #
  #
  # TODO is it code duplication
  #
  def decode_amiga_word file_data, offset
    byte1 = file_data.getbyte offset
    byte2 = file_data.getbyte offset + 1
    value = (byte1 << 8) | byte2
    value = (value & 0x8000) != 0 ? -((value ^ 0xFFFF) + 1) : value
    value
  end

  def set_attr attr_name
    offset = T_SPEC[attr_name][:offset] + @s_offset
    size   = T_SPEC[attr_name][:bytes]
    @mod_data[offset, size]
  end
end
