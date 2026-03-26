#
# A pattern has line and a line has cell
#
class Cell

  include LoadTool
  include CellBin
  include CellInfo
  attr_reader :sample_number, :note_period,
              :effect_command, :effect_argument

  def initialize cell_data
    @cell_data       = cell_data
    @sample_number   = read_sample_number cell_data
    @note_period     = read_note_period cell_data
    @effect_command  = read_effect_command cell_data
    @effect_argument = read_effect_argument cell_data
  end

  private

  def read_note_period cell_data
    ((cell_data[0] & 0x0F) << 8) | cell_data[1]
  end

  def read_effect_command cell_data
    (cell_data[3] & 0xF0) >> 4
  end

  def read_effect_argument cell_data
    cell_data[3] & 0x0F
  end
end
