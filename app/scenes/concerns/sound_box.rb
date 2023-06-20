module Concern::SoundBox
  def sound_section
    @sound.args = args
    @sound.tick
    @sound.stop  if args.inputs.keyboard.key_down.u
    @sound.start if args.inputs.keyboard.key_down.i

    @sound.select_down if args.inputs.keyboard.key_down.k
    @sound.select_up   if args.inputs.keyboard.key_down.j
    show_text
  end

end

class SfxPlayer
  attr_gtk
  attr_accessor :sample_count, :duration, :sample_rate

  def initialize args, mod, channel = :channel_0
    args     = args
    @samples = mod.samples
    @channel = channel
    puts "@channel"
    puts @channel
    init_sample_rate
    make_procs
    @sample_count = 0  # in tick
    @duration     = 60 # in tick
    @current_sound = 0
  end

  def tick
    @sample_count += 1
    if @sample_count > custom_duration
      stop
    end
  end

  def sample
    @samples[@current_sound]
  end

  def select_down
    @current_sound -= 1
    @current_sound = 0  if  @current_sound < 0
  end

  def select_up
    @current_sound += 1
    @current_sound = 31 if @current_sound > 31
  end

  def make_procs
    @generate_sounds = @samples.map do |sample|
      lambda do
        sample.normalized_data
      end
    end
  end

  def start
    args.audio[@channel] = {
      input: [1,
              custom_rate,
              @generate_sounds[@current_sound]]
    }
  end

  def stop
    args.audio[@channel] = nil
    @sample_count = 0
  end

  def custom_rate
    if sample.finetune = 0
      sample.length + 1
    else
      (@sample_rate / (2 * sample.finetune + 1)).to_i
    end
  end

  def custom_duration
    rate = @sample_rate / custom_rate
    rate == 1 ? 60 : rate * 5
  end

  def init_sample_rate
    # 28 672 Hz (qui correspond à 4 fois la fréquence de la note C3).
    # D'autres taux d'échantillonnage utilisés sont 16 000 Hz, 22 050 Hz, 32 000 Hz
    #@sample_rate = 44100
    #@sample_rate = 48000
    #@sample_rate = 856
    #@sample_rate = 28_672
    #@sample_rate = 3_672
    #@sample_rate = 41453
    #@sample_rate = 28_672
    @sample_rate = (70937892 / (856 * 2)).to_i
  end

end
