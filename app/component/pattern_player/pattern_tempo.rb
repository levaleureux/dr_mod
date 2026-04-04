#
# Tempo and effect dispatch for PatternPlayer.
#
# Effects are dispatched via hash lookup instead of case/when.
# Global effects (tempo, navigation) use @effect_argument.
# Channel effects (volume) also use @current_channel.
#
# To add a new effect: add an entry in GLOBAL_EFFECTS or
# CHANNEL_EFFECTS and implement the handler method.
#
# Tempo formula: frames_per_line = (60 * speed * 2.5) / bpm
# See doc/draft_posts/protracker_tempo.md
#
module PatternTempo

  # Global effects: affect the whole song (tempo, navigation)
  GLOBAL_EFFECTS = {
    0xF => :set_speed_or_bpm,
    0xB => :position_jump,
    0xD => :pattern_break,
  }.freeze

  # Channel effects: affect a single channel (volume, pitch)
  CHANNEL_EFFECTS = {
    0xC => :set_channel_volume,
    0xA => :volume_slide,
  }.freeze

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

  # Scan current row and dispatch effects.
  def apply_row_effects
    row = @pattern.rows[@current_line]
    row.each_with_index do |cell, ch|
      dispatch_effects cell, ch
    end
  end

  def dispatch_effects cell, ch
    @effect_command  = cell.effect_command
    @effect_argument = cell.effect_argument
    @current_channel = ch
    apply_global_effect
    apply_channel_effect
  end

  def apply_global_effect
    handler = GLOBAL_EFFECTS[@effect_command]
    send(handler, @effect_argument) if handler
  end

  def apply_channel_effect
    handler = CHANNEL_EFFECTS[@effect_command]
    return unless handler
    send(handler, @current_channel, @effect_argument)
  end

  # --- Global effect handlers ---

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
    target = (argument >> 4) * 10 + (argument & 0x0F)
    @current_pattern += 1
    @current_line = target - 1
  end

  # --- Channel effect handlers ---

  # Effect 0xC: set channel volume directly (0-64).
  def set_channel_volume ch, value
    @channel_volumes[ch] = value.clamp(0, 64)
  end

  # Effect 0xA: volume slide (pragmatic, once per line).
  # Total change = speed × step. See #59 for per-tick version.
  def volume_slide ch, value
    delta = slide_delta value
    new_vol = @channel_volumes[ch] + delta
    @channel_volumes[ch] = new_vol.clamp(0, 64)
  end

  # High nibble = slide up, low nibble = slide down.
  def slide_delta value
    up   = (value >> 4) & 0x0F
    down = value & 0x0F
    (up - down) * @speed
  end

  # --- Tempo conversion ---

  # Amiga: tick_rate = bpm * 2 / 5
  # DR: frames = (60 * speed * 2.5) / bpm
  def compute_frames_per_line
    ((60 * @speed * 2.5) / @bpm).round
  end
end
