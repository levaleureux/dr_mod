#
# Channels and shortcuts column for SidebarPanel.
#
module SidebarChannels
  include SidebarColors
  include LayoutConfig

  private

  def draw_right_col
    draw_channels
    draw_shortcuts
  end

  def draw_channels
    label_at right_col_x, top_y(4), "Channels", @fs, CH_COLOR
    sounds = @ctx[:played_sounds] || []
    sounds.each_with_index do |info, ch|
      draw_channel_label ch, info
    end
  end

  def draw_channel_label ch, info
    y_pos = top_y(4) - LINE_H * (ch + 1)
    muted = @ctx[:muted] && @ctx[:muted][ch]
    color = muted ? DIM : CH_COLOR
    label_at right_col_x, y_pos, "#{ch + 1}:#{info}", @fs, color
  end

  def draw_shortcuts
    y_base = top_y(4) - LINE_H * 6
    draw_shortcut_lines y_base
  end

  def draw_shortcut_lines y_base
    loop_txt = @ctx[:loop] ? "LOOP" : "loop"
    snd_txt  = @ctx[:sound] ? "SND" : "snd"
    label_at right_col_x, y_base, "SPC:play TAB:sample", @fs, DIM
    label_at right_col_x, y_base - LINE_H, "M:#{snd_txt} L:#{loop_txt}", @fs, DIM
    label_at right_col_x, y_base - LINE_H * 2, "W:reload 1-4:#{channels_txt}", @fs, DIM
  end

  def channels_txt
    return "1234" unless @ctx[:muted]
    @ctx[:muted].each_with_index.map do |muted, ch|
      muted ? "." : (ch + 1).to_s
    end.join
  end
end
