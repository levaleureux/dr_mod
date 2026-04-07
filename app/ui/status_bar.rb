#
# Vim-like status bar, always visible at the bottom.
# Displays: mode, position, tempo, contextual shortcuts.
#
# Uses JetBrains Mono for a clean monospace look.
#
class StatusBar
  include LayoutConfig
  attr_gtk

  BG_COLOR = { r: 30, g: 30, b: 35, a: 255 }.freeze
  TXT_COLOR = { r: 180, g: 180, b: 180 }.freeze
  MODE_BG = { r: 80, g: 180, b: 100 }.freeze
  MODE_TXT = { r: 20, g: 20, b: 20 }.freeze
  FONT = "fonts/jetbrains_mono.ttf"
  FONT_BOLD = "fonts/jetbrains_mono_bold.ttf"
  FONT_SIZE = -1

  def tick context
    draw_bar_bg
    draw_mode_badge context[:mode]
    draw_info context
  end

  private

  def draw_bar_bg
    args.outputs.solids << bg_rect
  end

  def bg_rect
    { x: screen_left, y: status_bar_y,
      w: screen_w, h: STATUS_BAR_H }.merge(BG_COLOR)
  end

  # Mode badge: colored background + bold text
  def draw_mode_badge mode
    label = mode_label mode
    badge_w = label.length * 9 + 16
    draw_badge_bg badge_w
    draw_badge_text label
  end

  MODE_LABELS = { title: "PLAY", sample: "SAMPLE" }.freeze

  def mode_label mode
    MODE_LABELS[mode] || mode.to_s.upcase
  end

  def draw_badge_bg badge_w
    args.outputs.primitives << {
      x: screen_left + 4, y: status_bar_y + 3,
      w: badge_w, h: STATUS_BAR_H - 6,
      primitive_marker: :solid }.merge(MODE_BG)
  end

  def draw_badge_text label
    args.outputs.primitives << badge_label_at(12, label)
  end

  def badge_label_at offset_x, text
    { x: screen_left + offset_x,
      y: status_bar_y + 18,
      text: text, font: FONT_BOLD,
      size_enum: FONT_SIZE - 2,
      primitive_marker: :label }.merge(MODE_TXT)
  end

  def draw_info context
    text = build_info_text context
    args.outputs.primitives << label_at(120, text, FONT, TXT_COLOR)
  end

  def label_at offset_x, text, font, color
    { x: screen_left + offset_x,
      y: status_bar_y + 20,
      text: text, font: font,
      size_enum: FONT_SIZE,
      primitive_marker: :label }.merge(color)
  end

  def build_info_text ctx
    parts = []
    parts << ctx[:mod_name] if ctx[:mod_name]
    parts << pat_info(ctx) if ctx[:pattern]
    parts << tempo_info(ctx) if ctx[:speed]
    parts.join("  \u2502  ")
  end

  def pat_info ctx
    "Pat:#{format('%02d', ctx[:pattern])}/#{ctx[:total_patterns]}" \
    " Ln:#{format('%02d', ctx[:line])}"
  end

  def tempo_info ctx
    "Spd:#{ctx[:speed]} BPM:#{ctx[:bpm]}"
  end
end
