#
# Pattern grid rendering: 64 rows x 4 channels.
# Responsive to LayoutConfig (sidebar_x, content_h, content_top).
# Style: alternating gray columns + green beat lines + red current line.
#
module PatternDraw
  include LayoutConfig

  ROW_COUNT = 64
  BG_LIGHT  = { r: 220, g: 220, b: 220 }.freeze
  BG_DARK   = { r: 195, g: 195, b: 195 }.freeze
  BEAT_COLOR = { r: 130, g: 188, b: 130 }.freeze

  private

  def pattern_section
    cache_pattern_geometry
    render_bg_columns
    render_beat_lines
    render_current_line @current_line, @color_tonic
    render_all_rows
  end

  # Cache geometry once per tick.
  def cache_pattern_geometry
    @pat_x = pattern_x
    @pat_w = pattern_w
    @pat_y_top = content_top
    @row_h = content_h.to_f / ROW_COUNT
    @col_w = @pat_w.to_f / 4
  end

  # --- Background columns (alternating gray) ---

  def render_bg_columns
    4.times do |ch|
      color = ch.even? ? BG_LIGHT : BG_DARK
      args.outputs.solids << channel_bg_rect(ch).merge(color)
    end
  end

  def channel_bg_rect ch
    { x: (@pat_x + @col_w * ch).to_i,
      y: STATUS_BAR_H,
      w: @col_w.ceil, h: content_h }
  end

  # --- Beat lines (every 16 rows) ---

  def render_beat_lines
    [0, 16, 32, 48].each do |line|
      render_current_line line, BEAT_COLOR
    end
  end

  # --- Current line highlight (full width band) ---

  def render_current_line row, color
    args.outputs.solids << {
      x: @pat_x, y: row_y(row),
      w: @pat_w, h: @row_h.ceil
    }.merge(color)
  end

  # --- Row text (4 cells per row) ---

  def render_all_rows
    ROW_COUNT.times do |row|
      render_row row
    end
  end

  def render_row row
    args.outputs.labels << row_label(row)
  end

  def row_label row
    { x: @pat_x + 8, y: row_y(row) + @row_h.to_i - 2,
      text: @pattern.row_info(row), size_enum: -5,
      vertical_alignment_enum: 2, alignment_enum: 0 }
  end

  # Y position of row N (top-down: row 0 at top)
  def row_y row
    (@pat_y_top - @row_h * (row + 1)).to_i
  end
end
