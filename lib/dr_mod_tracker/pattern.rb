#
#
#
#
class Pattern

  include LoadTool

  ATTR_LIST = %i(num rows)
  attr_accessor *ATTR_LIST

  def initialize mod_data, num
    @num      = num
    @size     = T_SPEC[:pattern_data][:bytes]
    @offset   = T_SPEC[:pattern_data][:offset] + @size * @num
    @mod_data = mod_data
    @rows     = []
    decode_rows
  end

  def decode_rows
    64.times do |line_offset|
      @rows << decode_pattern_line(@mod_data, @offset, line_offset)
    end
  end

  def puts_info
    puts "Pattern: #{@num}"
    even = 1
    64.times do |line_offset|
      even *= -1
      puts_row line_offset, @rows[line_offset], even
    end
  end

  def row_info line_offset
    row = @rows[line_offset]
    cell_infos = row.map &:info
    text       = cell_infos.join("\u2503")
    line       = "#{format('%02d', line_offset)}  #{text}|"
    line
  end

  def puts_row line_offset, row, even
    cell_infos = row.map &:info
    text       = cell_infos.join("\u2503")
    line       = "#{format('%02d', line_offset)}: #{text}|"
    if (line_offset % 8) == 0
      puts "\e[7m#{line}\e[0m"
    else
      puts (even > 0 ? line : "\e[37m#{line}\e[0m")
    end
    #puts (even > 0 ? line : "\e[43m#{line}\e[0m")

  end

  def decode_pattern_line(mod_data, pattern_offset, line_offset)
    line_data = mod_data[pattern_offset + (line_offset * 16), 16]

    note_bytes   = line_data.unpack("C*")
    note_effects = []

    note_bytes.each_slice(4) do |sample_byte, note_byte, effect_byte, effect_data_byte|
      #note        = (note_byte & 0x0F)
      #sample      = ((note_byte & 0xF0) >> 4)
      #instrument  = (instrument_byte & 0xF0) | ((effect_byte & 0xF0) >> 4)
      #effect      = (effect_byte & 0x0F)
      #effect_data = effect_data_byte

      #note_effects << Cell.new(note, sample, instrument, effect, effect_data)
      note_effects << Cell.new([sample_byte, note_byte, effect_byte, effect_data_byte])
    end

    return note_effects
  end

end

class Cell
  include LoadTool
  attr_reader :sample_number, :note_period, :effect_command, :effect_argument

  def initialize(cell_data)
    decode_cell(cell_data)
  end

  def decode_cell(cell_data)
    @sample_number = (cell_data[0] & 0xF0) | ((cell_data[2] & 0xF0) >> 4)
    @note_period = ((cell_data[0] & 0x0F) << 8) | cell_data[1]
    @effect_command = (cell_data[3] & 0xF0) >> 4
    @effect_argument = cell_data[3] & 0x0F
  end

  def info_verbose
        "Sample Number: #{@sample_number}, Note Period: #{@note_period}, Effect Command: #{@effect_command}, Effect Argument: #{@effect_argument}"
  end

  def info
    note = @note_period == 0 ? "   " :  T_SPEC[:notes][@note_period]
    note = note == "" ? "blk" : note
    data = [
      format('%02d', @sample_number),
      note,
      info_effect(@effect_command),
      info_effect(@effect_argument)
    ]
    data.join("\u2503")
  end

  def info_effect val
    val == 0 ? "   " : format('%03d', val)
  end
end
