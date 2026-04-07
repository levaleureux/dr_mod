#
# Song positions column for SidebarPanel.
#
module SidebarPositions
  include SidebarColors
  include LayoutConfig

  private

  def draw_left_col
    draw_pos_header
    draw_pos_list
  end

  def draw_pos_header
    label_at sidebar_x + 10, top_y(4), "Positions", @fs, TXT
  end

  def draw_pos_list
    return unless @ctx[:song_positions]
    @ctx[:song_positions].each_with_index do |pat_num, pos|
      draw_pos_cursor pos
      draw_pos_entry pos, pat_num
    end
  end

  def draw_pos_cursor pos
    return unless @ctx[:current_pattern] == pos
    # Label baseline is below pos_y. Cursor sits below the line,
    # with 2px upward offset for visual alignment.
    args.outputs.solids << {
      x: sidebar_x + 6, y: pos_y(pos) - LINE_H + 1,
      w: col_w - 10, h: LINE_H - 1
    }.merge(CURSOR)
  end

  def draw_pos_entry pos, pat_num
    color = @ctx[:current_pattern] == pos ? TXT : DIM
    y_pos = pos_y pos
    return if y_pos < STATUS_BAR_H
    txt = "#{format('%02d', pos + 1)} #{pat_num}"
    label_at sidebar_x + 10, y_pos, txt, @fs, color
  end

  def pos_y pos
    top_y(4) - LINE_H * (pos + 1)
  end
end
