#
# tool for byte
#
module LoadTool

  T_SPEC = PROTRACKER_1_1_B

  def decode_amiga_word file_data, offset
    high_byte = file_data.getbyte offset
    low_byte  = file_data.getbyte offset + 1
    value = (high_byte << 8) | low_byte
    value = (value & 0x8000) != 0 ? -((value ^ 0xFFFF) + 1) : value
    value
  end

  def set_attr attr_name
    offset = T_SPEC[attr_name][:offset] + @s_offset
    size   = T_SPEC[attr_name][:bytes]
    @mod_data[offset, size]
  end
end
