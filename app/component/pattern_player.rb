#
# PatternPlayer: plays MOD patterns and handles navigation.
# Modules: PatternDraw, PatternSideBar, PatternAudio,
#          PatternTempo, PatternInput.
#
class PatternPlayer
  include PatternDraw
  include PatternSideBar
  include PatternAudio
  include PatternTempo
  include PatternInput
  attr_gtk

  def initialize args, mod, channels
    @args     = args
    @mod      = mod
    @patterns = mod.patterns
    @channels = channels
    init_defaults
  end

  def tick
    @pattern = @patterns[@current_pattern]
    tick_update
    tick_render
  end

  private

  def tick_update
    handle_input
    advance_if_playing
    clamp_position
  end

  def tick_render
    side_bar
    pattern_section
  end

  def init_defaults
    init_state
    init_ui
  end

  def init_state
    init_playback_state
    init_tempo
  end

  def init_playback_state
    @current_line    = 5
    @current_pattern = 0
    @playing         = false
    @with_sound      = false
    @loop_pattern    = false
  end

  def init_ui
    @color_tonic     = { r: 208, g: 130, b: 130 }
    @played_sounds   = ["", "", "", ""]
    @muted_channels  = [false, false, false, false]
  end

  def advance_if_playing
    return unless playing_next_line?
    apply_row_effects
    play_row_sounds
    @current_line += 1
  end

  # TODO FIX pattern 12 break
  def clamp_position
    wrap_line
    clamp_pattern
  end

  def wrap_line
    wrap_line_up if @current_line < 0
    wrap_line_down if @current_line >= 64
  end

  def wrap_line_up
    @current_line = 63
    @current_pattern -= 1
  end

  # In loop mode, restart at line 0 of same pattern.
  def wrap_line_down
    @current_line = 0
    @current_pattern += 1 unless @loop_pattern
  end

  def clamp_pattern
    max = 11 # TODO use @mod.song.length
    @current_pattern = 0 if @current_pattern > max
    @current_pattern = max if @current_pattern < 0
  end
end
