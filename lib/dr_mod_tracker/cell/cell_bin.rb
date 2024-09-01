#
# A pattern has line and a line has cell
#
# see https://youtu.be/0_6eBiouooo?t=1046
# for a visual explenation
#
#note        = (note_byte & 0x0F)
#sample      = ((note_byte & 0xF0) >> 4)
#instrument  = (instrument_byte & 0xF0) | ((effect_byte & 0xF0) >> 4)
#effect      = (effect_byte & 0x0F)
#effect_data = effect_data_byte

#
#
module CellBin

  # 8-Bits for the sample number
  # 4 bits in Byte 1, the 4 first bits
  # 4 bits in Byte 3, the 4 first bits
  #
  def read_sample_number cell_bytes
    high_weights = high_bits(cell_bytes[0])
    low_weights  = high_bits(cell_bytes[2])
    # move low_bits by 4 column and merge with | operator
    # to create one Byte
    sample_number = high_weights | (low_weights >> 4)
    puts "sample_number #{cell_bytes} #{sample_number}"
    sample_number
  end

  # keep only the 4 left bits
  # by masking with 0xF0 = 11110000
  def high_bits byte
    byte & 0xF0
  end

end
