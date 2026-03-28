#
# SfxPlayer: audio playback engine for MOD samples.
# Handles play/stop, sample selection, rate control.
# Waveform rendering is in SfxDraw module.
#
# Amiga PAL frequency: 7,093,789.2 Hz
# Formula: hz = AMIGA_PAL_FREQ / (period * 2)
# C-3 (period 214) = 16575 Hz — default playback note
#
# see #23 for logging system
# see #32 for virtual keyboard (note selection)
#
class SfxPlayer
  include SfxDraw
  attr_gtk
  attr_accessor :sample_count, :duration, :sample_rate

  AMIGA_PAL_FREQ = 7_093_789.2
  C3_PERIOD = 214

  def initialize args, mod, channel = :channel_0
    init_audio args, mod, channel
    init_counters
  end

  def tick
    draw_rate_label
    tick_draw args
  end

  def sample
    @samples[@current_sound]
  end

  def select_down
    @current_sound -= 1
    @current_sound = 0 if @current_sound < 0
    init_draw args
  end

  def select_up
    @current_sound += 1
    @current_sound = 31 if @current_sound > 31
    init_draw args
  end

  def rate_down
    @sample_rate -= 1000
    @sample_rate = 0 if @sample_rate < 0
  end

  def rate_up
    @sample_rate += 1000
    @sample_rate = 500_000 if @sample_rate > 500_000
  end

  def start
    stop
    sound = build_one_shot @samples[@current_sound]
    args.audio[@channel] = {
      input: [1, custom_rate, sound]
    }
  end

  def stop
    args.audio[@channel] = nil
    @sample_count        = 0
  end

  # Playback rate for current note (C-3 default, see #32)
  def custom_rate
    (AMIGA_PAL_FREQ / (C3_PERIOD * 2)).to_i
  end

  def custom_duration
    sample.length / custom_rate * 60
  end

  private

  def init_audio args, mod, channel
    args     = args
    @samples = mod.samples
    @channel = channel
    init_sample_rate
    make_procs
  end

  def init_counters
    @sample_count  = 0
    @duration      = 60
    @current_sound = 0
  end

  def init_sample_rate
    @sample_rate = (70937892 / (856 * 2)).to_i
  end

  def check_duration
    @sample_count += 1
    stop if @sample_count > custom_duration
  end

  def make_procs
    @generate_sounds = @samples.map do |s|
      lambda { s.normalized_data }
    end
  end

  # One-shot lambda: plays sample data once, then silence.
  def build_one_shot s
    played = false
    lambda { played ? [] : (played = true; s.normalized_data) }
  end
end
