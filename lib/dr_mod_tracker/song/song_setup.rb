#
# Use for setting,
# unpacking will be a better name
#
module SongSetup

  private

  def set_name
    @name = set_attr :song_name
  end

  def set_length
    @length = set_attr(:song_length)
      .unpack("C").first
  end

  def set_tracker_byte
    @tracker_byte = set_attr(:tracker_byte)
      .unpack("C").first
  end

  # array
  #
  def set_song_positions
    # TODO ???? constant issue ???
    T_SPEC          = PROTRACKER_1_1_B
    offset          = T_SPEC[:song_positions][:offset]
    @song_positions = @mod_data[offset, 128].unpack("C*")
  end

  def set_format_signature
    @format_signature = set_attr :is_mk
  end

end
