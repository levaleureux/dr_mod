#
# TODO extract puts to a module
#
module SongPrint

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

end
