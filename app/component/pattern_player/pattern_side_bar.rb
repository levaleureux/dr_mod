#
# Side bar UI for PatternPlayer.
# Displays title, shortcuts, channel info, and song position list.
#
module PatternSideBar

  private

  def side_bar
    draw_title
    draw_channel_info
    draw_song_positions
  end

  def draw_title
    draw_label(-8, -3, "GoodEnoughTraker", 16)
    draw_label(-1, 18, "pattern box", 8)
    draw_shortcuts
  end

  def draw_shortcuts
    loop_txt = @loop_pattern ? "LOOP ON" : "loop off"
    snd_txt  = @with_sound ? "SND ON" : "snd off"
    draw_label(-9, 18, "SPC:play M:#{snd_txt} L:#{loop_txt}", 1)
    draw_label(-10, 18, "S:sample W:reload 1-4:#{channels_txt}", 1)
  end

  def channels_txt
    @muted_channels.each_with_index.map do |muted, ch|
      muted ? "." : (ch + 1).to_s
    end.join
  end

  def draw_channel_info
    update_played_sounds
    @played_sounds.each_with_index do |info, index|
      draw_label(-5 + index, 18, "Chanel #{index} : #{info}", 1)
    end
  end

  def update_played_sounds
    @pattern.rows[@current_line].each_with_index do |cell, index|
      next if cell.note_period == 0
      num = cell.sample_number
      @played_sounds[index] = "#{cell.note_period} : #{num} #{@mod.samples[num].name}"
    end
  end

  def draw_song_positions
    draw_song_header
    draw_position_cursor
    draw_position_list
  end

  def draw_song_header
    text = "song positions - Pattern : #{@current_pattern}/#{@mod.song.length}"
    draw_label(1, 18, text, 1)
  end

  def draw_position_cursor
    rect = position_cursor_rect
    args.outputs.solids << rect.merge(**@color_tonic)
  end

  def position_cursor_rect
    rect = args.layout.rect(row: 3, col: 18, w: 4, h: 1)
    adjust_cursor rect
  end

  def adjust_cursor rect
    rect.y += -31 - @current_pattern * 22
    rect.h -= 25
    rect.w -= 52
    rect.x -= 20
    rect
  end

  def draw_position_list
    rect = args.layout.rect(row: 3, col: 18, w: 4, h: 1)
    @mod.song.length.times do |pos|
      draw_position_entry rect, pos
    end
  end

  def draw_position_entry rect, pos
    rect.y -= 22
    pos_text = format('%02d', pos + 1)
    pattern_num = @mod.song.song_positions[pos]
    draw_label_rect rect, "#{pos_text} #{pattern_num}", 1
  end

  def draw_label row, col, text, size
    args.outputs.labels << args.layout.rect(row: row, col: col)
      .merge(text: text, vertical_alignment_enum: 1,
             alignment_enum: 0, size_enum: size)
  end

  def draw_label_rect rect, text, size
    args.outputs.labels << rect.merge(
      text: text, vertical_alignment_enum: 1,
      alignment_enum: 0, size_enum: size)
  end
end
