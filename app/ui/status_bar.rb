#
# Vim-like status bar, always visible at the bottom.
# Displays: mode, position, tempo, contextual shortcuts.
#
# Receives a context hash from the current scene:
#   { mode:, pattern:, line:, speed:, bpm:, shortcuts: }
#
class StatusBar
  include LayoutConfig
  attr_gtk

  BG_COLOR = { r: 40, g: 40, b: 40 }.freeze
  TXT_COLOR = { r: 220, g: 220, b: 220 }.freeze
  MODE_COLOR = { r: 100, g: 200, b: 100 }.freeze

  def tick context
    draw_bar_bg
    draw_mode context[:mode]
    draw_info context
  end

  private

  def draw_bar_bg
    args.outputs.solids << {
      x: screen_left, y: status_bar_y,
      w: screen_w, h: STATUS_BAR_H
    }.merge(BG_COLOR)
  end

  def draw_mode mode
    args.outputs.labels << {
      x: screen_left + 8, y: status_bar_y + 18,
      text: mode.to_s.upcase,
      size_enum: 1
    }.merge(MODE_COLOR)
  end

  def draw_info context
    text = build_info_text context
    args.outputs.labels << {
      x: screen_left + 120, y: status_bar_y + 18,
      text: text, size_enum: 1
    }.merge(TXT_COLOR)
  end

  def build_info_text ctx
    parts = []
    parts << pat_info(ctx) if ctx[:pattern]
    parts << tempo_info(ctx) if ctx[:speed]
    parts << ctx[:shortcuts] if ctx[:shortcuts]
    parts.join(" | ")
  end

  def pat_info ctx
    "Pat:#{ctx[:pattern]}/#{ctx[:total_patterns]}" \
    " Ln:#{ctx[:line]}"
  end

  def tempo_info ctx
    "Spd:#{ctx[:speed]} BPM:#{ctx[:bpm]}"
  end
end
