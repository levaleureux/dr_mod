#
# TODO extract puts to a module
#
class Song
  include LoadTool
  include SongSetup
  include SongPrint
  attr_accessor :name, :song_name, :length, :tracker_byte,
    :song_positions, :format_signature, :samples_data_offset

  # mod_data is loaded in DrMod
  #
  def initialize mod_data
    @s_offset = 0
    @mod_data = mod_data
    set_elements
  end

  def pattern_count
    puts "songspositions"
    puts @song_positions
    @song_positions.max
  end

  # TODO extract to constant
  def pattern_size
    1024 # pattern_lines 64 * line_size 16
  end

  def samples_count
    32
  end

  #
  # this is used by sample to know where to start
  #
  def samples_start_at
    1084 + (pattern_count * pattern_size)
  end

  private

  def set_elements
    set_name
    set_length
    set_tracker_byte
    set_song_positions
    set_format_signature
  end
end
