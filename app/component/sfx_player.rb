#
# SfxPlayer: audio playback engine for MOD samples.
# Handles play/stop, sample selection, rate control.
# Waveform rendering is in SfxDraw module.
#
# see #23 for logging system
#
class SfxPlayer
  include SfxDraw
  attr_gtk
  attr_accessor :sample_count, :duration, :sample_rate

  def initialize args, mod, channel = :channel_0
    init_audio args, mod, channel
    init_counters
  end

  def tick
    check_duration
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
    args.audio[@channel] = {
      input: [1, custom_rate, @generate_sounds[@current_sound]]
    }
  end

  def stop
    args.audio[@channel] = nil
    @sample_count        = 0
  end

  def custom_rate
    if sample.finetune == 0
      sample.length + 1
    else
      (@sample_rate / (2 * sample.finetune + 1)).to_i
    end
  end

  def custom_duration
    rate = @sample_rate / custom_rate
    rate == 1 ? 60 : rate * 5
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
end
