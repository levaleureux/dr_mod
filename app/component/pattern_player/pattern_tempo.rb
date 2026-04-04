#
# Tempo and effect dispatch for PatternPlayer.
# Handles: 0xF (speed/BPM), 0xB (position jump), 0xD (pattern break).
#
# Tempo formula: frames_per_line = (60 * speed * 2.5) / bpm
# See doc/draft_posts/protracker_tempo.md
#
module PatternTempo

  private

  # ProTracker default: speed=6, bpm=125 → 7 frames/line
  def init_tempo
    @speed = 6
    @bpm   = 125
    @frames_per_line = compute_frames_per_line
  end

  def playing_next_line?
    args.tick_count % @frames_per_line == 0 && @playing
  end

  # Scan current row for effects that affect playback.
  def apply_row_effects
    row = @pattern.rows[@current_line]
    row.each_with_index do |cell, ch|
      apply_cell_effect cell, ch
    end
  end

  def apply_cell_effect cell, ch
    apply_global_effect cell
    apply_channel_effect cell, ch
  end

  def apply_global_effect cell
    case cell.effect_command
    when 0xF then set_speed_or_bpm cell.effect_argument
    when 0xB then position_jump cell.effect_argument
    when 0xD then pattern_break cell.effect_argument
    end
  end

  def apply_channel_effect cell, ch
    case cell.effect_command
    when 0xC then set_channel_volume ch, cell.effect_argument
    end
  end

  # Speed (1-31): ticks per line.
  # BPM (32+): beats per minute.
  def set_speed_or_bpm value
    return if value == 0
    value < 32 ? @speed = value : @bpm = value
    @frames_per_line = compute_frames_per_line
  end

  # Jump to song position xx, start at line 0.
  def position_jump position
    @current_pattern = position
    @current_line = -1
  end

  # End pattern, next pattern at line x*10 + y.
  # Argument is BCD: high nibble = tens, low = ones.
  def pattern_break argument
    target_line = (argument >> 4) * 10 + (argument & 0x0F)
    @current_pattern += 1
    @current_line = target_line - 1
  end

  # Effect 0xC: set channel volume directly (0-64).
  def set_channel_volume ch, value
    @channel_volumes[ch] = value.clamp(0, 64)
  end

  # Amiga: tick_rate = bpm * 2 / 5
  # DR: frames = 60 * speed / tick_rate
  #            = (60 * speed * 2.5) / bpm
  def compute_frames_per_line
    ((60 * @speed * 2.5) / @bpm).round
  end
end
