#
# Tempo management for PatternPlayer.
# Converts Amiga CIA tick timing to DragonRuby 60 FPS frames.
#
# Formula: frames_per_line = (60 * speed * 2.5) / bpm
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

  # Scan current row for tempo effects (0xF).
  def apply_row_effects
    @pattern.rows[@current_line].each do |cell|
      apply_tempo_effect cell
    end
  end

  def apply_tempo_effect cell
    return unless cell.effect_command == 0xF
    set_speed_or_bpm cell.effect_argument
  end

  # Speed (1-31): ticks per line.
  # BPM (32+): beats per minute.
  def set_speed_or_bpm value
    return if value == 0
    value < 32 ? @speed = value : @bpm = value
    @frames_per_line = compute_frames_per_line
  end

  # Amiga: tick_rate = bpm * 2 / 5
  # DR: frames = 60 * speed / tick_rate
  #            = (60 * speed * 2.5) / bpm
  def compute_frames_per_line
    ((60 * @speed * 2.5) / @bpm).round
  end
end
