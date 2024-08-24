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
    init_attrs # mod_data
    decode_rows
  end

  def decode_rows
    64.times do |line_offset|
      @rows << decode_pattern_line(line_offset)
    end
  end

  def decode_pattern_line line_offset
    line_data   = @mod_data[@pattern_offset + (line_offset * 16), 16]
    @note_bytes = line_data.unpack("C*")
    build_note_effects []
  end

  private

  # NOTE: each_slice(4)  ->
  #  sample_byte, note_byte, effect_byte, effect_data_byte|
  #
  def build_note_effects note_effects
    @note_bytes.each_slice(4) do |attrs|
      note_effects << Cell.new(attrs)
    end
    return note_effects
  end

  def init_attrs
    T_SPEC          = PROTRACKER_1_1_B
    pattern_data    = T_SPEC[:pattern_data]
    @size           = pattern_data[:bytes]
    @pattern_offset = pattern_data[:offset] + @size * @num
    @rows           = []
  end

end
