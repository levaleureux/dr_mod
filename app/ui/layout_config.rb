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

  # Use the full allscreen area for responsive layout.
  # allscreen values extend beyond the 1280x720 safe area
  # when the window is larger than default.
  def screen_w
    screen_right - screen_left
  end

  def screen_h
    screen_top - screen_bottom
  end

  def screen_bottom
    [args.grid.allscreen_bottom, 0].min
  end

  def screen_left
    [args.grid.allscreen_left, 0].min
  end

  def screen_right
    [args.grid.allscreen_right, 1280].max
  end

  def screen_top
    [args.grid.allscreen_top, 720].max
  end

  # --- Status bar (vim-like, always at bottom) ---

  STATUS_BAR_H = 26

  def content_h
    screen_top - screen_bottom - STATUS_BAR_H
  end

  def status_bar_y
    screen_bottom
  end

  # Content starts above the status bar
  def content_top
    screen_top
  end

  # Font size for sidebar text.
  # Moderate boost (+3) for readability without blur.
  # TODO #64: bitmap font for pixel-perfect scaling.
  def dynamic_font_size base_size = 0
    base_size + 3
  end

  # --- Panel proportions ---

  # Sidebar on the right, takes 25% of width
  def sidebar_w
    (screen_w * 0.25).to_i
  end

  def sidebar_x
    screen_right - sidebar_w
  end

  # Pattern area takes the left 75%
  def pattern_x
    screen_left
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
