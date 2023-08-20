#
# TODO naming there is row and line
# 2 word for the same thing
#
#
class Pattern

  include LoadTool
  include PatternPrint

  attr_accessor  :num, :rows

  def initialize mod_data, num
    @num      = num
    @mod_data = mod_data
    init_attrs mod_data
    decode_rows
  end

  def decode_rows
    64.times do |line_offset|
      @rows << decode_pattern_line(line_offset)
    end
  end

  #note        = (note_byte & 0x0F)
  #sample      = ((note_byte & 0xF0) >> 4)
  #instrument  = (instrument_byte & 0xF0) | ((effect_byte & 0xF0) >> 4)
  #effect      = (effect_byte & 0x0F)
  #effect_data = effect_data_byte
  #note_effects << Cell.new(note, sample, instrument, effect, effect_data)
  def decode_pattern_line line_offset
    line_data  = @mod_data[@pattern_offset + (line_offset * 16), 16]
    note_bytes = line_data.unpack("C*")
    build_note_effects note_bytes, []
  end

  private

  def build_note_effects note_bytes, note_effects
    note_bytes.
      each_slice(4) do |sample_byte, note_byte, effect_byte, effect_data_byte|
        attrs = [sample_byte, note_byte, effect_byte, effect_data_byte]
        note_effects << Cell.new(attrs)
      end ; return note_effects
  end

  def init_attrs
    @size           = T_SPEC[:pattern_data][:bytes]
    @pattern_offset = T_SPEC[:pattern_data][:offset] + @size * @num
    @rows           = []
  end

end
