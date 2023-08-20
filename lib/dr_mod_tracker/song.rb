#
#
#
#
class Song
  include LoadTool
  ATTR_LIST = %i()
  attr_accessor :name, :song_name, :length, :tracker_byte,
    :song_positions, :format_signature, :samples_data_offset

  def initialize mod_data
    @s_offset = 0
    @mod_data = mod_data
    set_elements
  end

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
    offset = T_SPEC[:song_positions][:offset]
    @song_positions = @mod_data[offset, 128].unpack("C*")
  end

  def set_format_signature
    @format_signature = set_attr :is_mk
  end

  def pattern_count
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
    1084 + pattern_count * pattern_size
  end

  def puts_info
    puts_song_info
    puts "song_positions:"
    puts_song_positions
  end

  def puts_song_positions
    song_positions      = @song_positions
    formatted_positions = song_positions
      .take(@length).map { |pos| format('%02d', pos)  }
    blocks = formatted_positions.each_slice(16).to_a

    puts_line_blocks blocks
  end

  private
  def puts_song_info
    puts "name:   #{@name}"
    puts "length: #{@length} patterns"
    puts "Tag:    ->#{@format_signature}<-"
    puts "-"
    puts "tracker_byte: #{@tracker_byte}"
  end

  def puts_line_blocks
    blocks.each do |block|
      line = block.join(' ')
      puts line
      puts
    end
  end

  def set_elements
    set_name
    set_length
    set_tracker_byte
    set_song_positions
    set_format_signature
  end
end
