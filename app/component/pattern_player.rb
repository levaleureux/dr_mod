#
# PatternPlayer: plays MOD patterns and handles navigation.
# Rendering is split into PatternDraw (grid) and
# PatternSideBar (title, channels, song positions).
# Audio playback is in PatternAudio module.
#
class PatternPlayer
  include PatternDraw
  include PatternSideBar
  include PatternAudio
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

  def handle_input
    handle_toggle_keys
    handle_navigation_keys
  end

  def handle_toggle_keys
    @with_sound = !@with_sound if args.inputs.keyboard.key_down.m
    @playing = !@playing if args.inputs.keyboard.key_down.space
    @loop_pattern = !@loop_pattern if args.inputs.keyboard.key_down.l
    toggle_channels
  end

  # Keys 1-4 mute/unmute individual channels.
  def toggle_channels
    4.times do |i|
      toggle_channel i if channel_key_down?(i)
    end
  end

  def channel_key_down? i
    args.inputs.keyboard.key_down.send("#{i + 1}")
  end

  def toggle_channel i
    @muted_channels[i] = !@muted_channels[i]
  end

  def handle_navigation_keys
    @current_line -= 1 if args.inputs.keyboard.key_down.up
    @current_line += 1 if args.inputs.keyboard.key_down.down
    @current_pattern -= 1 if args.inputs.keyboard.key_down.left
    @current_pattern += 1 if args.inputs.keyboard.key_down.right
  end

  def advance_if_playing
    return unless args.tick_count % 10 == 0 && @playing
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
  # Otherwise advance to next pattern.
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
