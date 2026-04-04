#
# Pattern rendering: draws the 64-row pattern grid
# with colored highlight on current and beat lines.
#
# See #20 for vertical alignment analysis.
#
module PatternDraw

  private

  def pattern_section
    render_bg_columns
    render_beat_lines
    render_current_line @current_line, @color_tonic
    render_all_rows
  end

  def render_bg_columns
    render_bg_col 3, -71
    render_bg_col 7, 131
  end

  def render_beat_lines
    color = { r: 130, g: 188, b: 130 }
    [0, 16, 32, 48].each do |line|
      render_current_line line, color
    end
  end

  def render_all_rows
    64.times do |line|
      render_line @pattern, line, line
    end
  end

  def render_bg_col col, x_offset
    rect = bg_col_rect col, x_offset
    args.outputs.solids << rect
  end

  def bg_col_rect col, x_offset
    grey = 200
    rect = args.layout.rect(row: 0, col: col, w: 4, h: 1)
      .merge(r: grey, g: grey, b: grey)
    adjust_bg_col rect, x_offset
  end

  def adjust_bg_col rect, x_offset
    rect.x += x_offset
    rect.h = 1300 - 16
    rect.y -= 1000 - 22
    rect
  end

  # See #20 analysis for vertical alignment details.
  def render_current_line row, color
    rect = current_line_rect row, color
    args.outputs.solids << rect
  end

  def current_line_rect row, color
    rect = args.layout.rect(row: 0, col: 1, w: 16, h: 1)
      .merge(**color)
    adjust_current_line rect, row
  end

  # Same Y formula as text (910 - row*20), offset -10
  # to center the 20px band on the text line.
  def adjust_current_line rect, row
    rect.w += 25
    rect.x -= 3
    rect.h = 20
    rect.y = 640 - row * 20 + 270 - 10
    rect
  end

  def render_line pattern, num, row
    rect = line_label_rect row
    args.outputs.labels << rect.merge(
      text: pattern.row_info(num),
      vertical_alignment_enum: 1,
      alignment_enum: 0, size_enum: 1)
  end

  def line_label_rect row
    rect = args.layout.rect(row: row, col: 1)
    rect.y = 640 - row * 20 + 270
    rect
  end
end
