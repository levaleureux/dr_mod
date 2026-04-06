#
# Sidebar panel (right side): two columns layout.
# Left: song positions (SidebarPositions module).
# Right: channels + shortcuts (SidebarChannels module).
#
class SidebarPanel
  include LayoutConfig
  include SidebarColors
  include SidebarPositions
  include SidebarChannels
  attr_gtk

  def tick context
    @ctx = context
    @fs = dynamic_font_size(-2)
    draw_bg
    draw_content
  end

  def draw_content
    draw_header
    draw_left_col
    draw_right_col
  end

  private

  def draw_bg
    args.outputs.solids << {
      x: sidebar_x, y: screen_bottom + STATUS_BAR_H,
      w: sidebar_w, h: content_h
    }.merge(BG)
  end

  def col_w
    (sidebar_w * 0.45).to_i
  end

  def right_col_x
    sidebar_x + col_w + 10
  end

  def draw_header
    title_size = dynamic_font_size(2)
    label_at sidebar_x + 10, top_y(1), "GoodEnoughTraker", title_size, TXT
    label_at sidebar_x + 10, top_y(2), "Lateral thinking", @fs - 2, DIM
  end

  def top_y row
    content_top - row * 18
  end

  def label_at pos_x, pos_y, text, size, color
    args.outputs.labels << {
      x: pos_x, y: pos_y,
      text: text, font: FONT,
      size_enum: size
    }.merge(color)
  end
end
