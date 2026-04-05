#
# Dynamic layout configuration for dr_mod.
# All dimensions are calculated from screen size,
# making the UI responsive to window resizing.
#
# Usage: include LayoutConfig, then call layout methods.
# All values recalculate based on current args.grid.
#
module LayoutConfig

  # --- Screen dimensions (read from DR grid) ---

  def screen_w
    args.grid.allscreen_right - args.grid.allscreen_left
  end

  def screen_h
    args.grid.allscreen_top - args.grid.allscreen_bottom
  end

  # Edges of the actual screen (allscreen mode)
  def screen_bottom
    args.grid.allscreen_bottom
  end

  def screen_left
    args.grid.allscreen_left
  end

  def screen_right
    args.grid.allscreen_right
  end

  def screen_top
    args.grid.allscreen_top
  end

  # --- Status bar (vim-like, always at bottom) ---

  STATUS_BAR_H = 24

  def content_h
    screen_h - STATUS_BAR_H
  end

  def status_bar_y
    screen_bottom
  end

  # --- Panel proportions ---

  # Sidebar takes 25% of width
  def sidebar_w
    (screen_w * 0.25).to_i
  end

  # Pattern area takes the remaining 75%
  def pattern_x
    sidebar_w
  end

  def pattern_w
    screen_w - sidebar_w
  end

  # --- Pattern grid ---

  ROW_HEIGHT = 20

  def pattern_y_for row
    content_h - ROW_HEIGHT - (row * ROW_HEIGHT)
  end

  # --- Waveform (relative to content area) ---

  def waveform_bounds
    { x: (screen_w * 0.05).to_i,
      y: (content_h * 0.7).to_i,
      w: (screen_w * 0.8).to_i,
      h: (content_h * 0.15).to_i }
  end
end
