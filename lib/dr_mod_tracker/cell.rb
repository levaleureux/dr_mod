#
# A pattern has line and a line has cell
#
class Cell

  include LoadTool
  attr_reader :sample_number, :note_period, :effect_command, :effect_argument

  #note        = (note_byte & 0x0F)
  #sample      = ((note_byte & 0xF0) >> 4)
  #instrument  = (instrument_byte & 0xF0) | ((effect_byte & 0xF0) >> 4)
  #effect      = (effect_byte & 0x0F)
  #effect_data = effect_data_byte
  def initialize cell_data
    @sample_number   = (cell_data[0] & 0xF0) | ((cell_data[2] & 0xF0) >> 4)
    @note_period     = ((cell_data[0] & 0x0F) << 8) | cell_data[1]
    @effect_command  = (cell_data[3] & 0xF0) >> 4
    @effect_argument = cell_data[3] & 0x0F
  end

  def info_verbose
    [ "Sample Number: #{@sample_number},  ",
      "Note Period: #{@note_period}, ",
      "Effect Command: #{@effect_command}, ",
      "Effect Argument: #{@effect_argument}"
    ]
  end

  def info
    note = @note_period == 0 ? "   " :  T_SPEC[:notes][@note_period]
    note = note == "" ? "blk" : note
    data(note).join("\u2503")
  end

  def info_effect val
    val == 0 ? "   " : format('%03d', val)
  end

  private

  def data note
    [ format('%02d', @sample_number),
      note,
      info_effect(@effect_command),
      info_effect(@effect_argument)
    ]
  end
end
