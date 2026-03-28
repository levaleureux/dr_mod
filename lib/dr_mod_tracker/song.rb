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

  # Number of patterns stored in the file.
  # song_positions contains pattern indices (0-based).
  # max gives the highest index, +1 for the count.
  # e.g. patterns 0..17 → max=17 → count=18
  def pattern_count
    @song_positions.max + 1
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
