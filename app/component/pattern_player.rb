#
# PatternPlayer: plays MOD patterns and handles navigation.
# Rendering is split into PatternDraw (grid) and
# PatternSideBar (title, channels, song positions).
#
class PatternPlayer
  include PatternDraw
  include PatternSideBar
  attr_gtk

  WAV_SAMPLES = %w(x_01_Kick A3 B3 C3 E3 jazz-2 jazz-3 kick-1 snare-1.wav F3 G3 treble-1).freeze

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
  end

  def init_ui
    @color_tonic   = { r: 208, g: 130, b: 130 }
    @played_sounds = ["", "", "", ""]
  end

  def handle_input
    handle_toggle_keys
    handle_navigation_keys
  end

  def handle_toggle_keys
    @with_sound = !@with_sound if args.inputs.keyboard.key_down.m
    @playing = !@playing if args.inputs.keyboard.key_down.space
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

  def wrap_line_down
    @current_line = 0
    @current_pattern += 1
  end

  def clamp_pattern
    max = 11 # TODO use @mod.song.length
    @current_pattern = 0 if @current_pattern > max
    @current_pattern = max if @current_pattern < 0
  end

  def play_row_sounds
    @channels.count.times do |num|
      play_channel_sound num
    end
  end

  def play_channel_sound num
    cell = @pattern.rows[@current_line][num]
    return if cell.note_period == 0
    play_wav_sound "channel_#{num}".to_sym, WAV_SAMPLES[num]
  end

  def play_wav_sound channel, name
    return unless @with_sound
    args.audio[channel] = { input: "sounds/#{name}.wav", gain: 0.05 }
  end
end
