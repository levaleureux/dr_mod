#
# Here is the heart of the difficulty
#
#
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
    @sample_count  = 0  # in tick
    @duration      = 60 # in tick
    @current_sound = 0
  end

  def tick
    @sample_count += 1
    if @sample_count > custom_duration
      stop
    end
    args.outputs.labels << args.layout.rect(row: 10, col: 1)
      .merge(text: "sample_rate: >> #{@sample_rate} <<",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
    tick_draw(args)
  end

  def sample
    @samples[@current_sound]
  end

  def select_down
    @current_sound -= 1
    @current_sound = 0 if @current_sound < 0
    init_draw(args)
  end

  def select_up
    @current_sound += 1
    @current_sound = 31 if @current_sound > 31
    init_draw(args)
  end

  def rate_down
    @sample_rate -= 1000
    @sample_rate = 0 if @sample_rate < 0
  end

  def rate_up
    @sample_rate += 1000
    @sample_rate = 500_000 if @sample_rate > 500_000
  end

  def make_procs
    @generate_sounds = @samples.map do |sample|
      lambda do
        sample.normalized_data
        # sample.data
      end
      sample.normalized_data
    end
  end

  def custom_rate
    if sample.finetune = 0
      sample.length    + 1
    else
      (@sample_rate / (2 * sample.finetune + 1)).to_i
    end
    (@sample_rate / (2 * sample.finetune + 1)).to_i
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

  def start
    args.audio[@channel] = {
      input: [1,
              custom_rate,
              @generate_sounds[@current_sound]]
    }
  end

  def stop
    args.audio[@channel] = nil
    @sample_count        = 0
  end

  def play_sound note_period
    sample = @generate_sounds[@current_sound]
    # Convertir le note_period en fréquence (Hz)
    # La formule utilisée est : fréquence = 7093789 / (2 * note_period)
    frequency = 7093789.0 / (2.0 * note_period)
    # Calculer un taux de lecture basé sur la fréquence
    # On va utiliser cette fréquence pour ajuster custom_rate
    custom_rate_2 = frequency_to_custom_rate(frequency)
    puts "custom rate:   #{custom_rate}"
    puts "custom rate 2: #{custom_rate_2}"
    puts "frequency:     #{frequency}"
    # Définir le son sur le canal donné avec la fréquence ajustée
    # args.audio[@channel] = { input: [1, custom_rate, sample] }
    args.audio[@channel] = { input: [1, (frequency * 1).to_i, sample] }
      # input: sample,
      # rate: custom_rate,
      # looping: false,  # Si vous voulez boucler, mettez à true
      # gain: 1.0        # Contrôle du volume, 1.0 = volume normal
  end

  # Convertir la fréquence en taux de lecture personnalisé pour args.audio
  def frequency_to_custom_rate(frequency)
    # Fréquence de référence typique pour la lecture normale d'un sample
    reference_frequency = 44100.0
    # Calculer le facteur de taux par rapport à la fréquence de référence
    custom_rate_2 = frequency / reference_frequency
    custom_rate_2
  end

  # TODO rate_up rate_down
  #
  # TODO draw wave with a parser line
  #
  # parser line qui est en adéquation avec la duration
  #
  # faire une duration
  # option de loop toggle ?
  #
  def init_draw(args)
    # Crée un render target (une surface sur laquelle dessiner)
    # waveform = args.render_target(:waveform)
    # args.render_target(:waveform).width = 640
    # args.render_target(:waveform).height = 100
    #puts "yooooooo"
    #puts args.render_target
    #puts args.render_target(:waveform)
    #args.render_target(:waveform).solids << [0, 0, 640, 100]
    #
    # waveform.width  = 640
    # waveform.height = 100

    # Tableau d'exemple de données normalisées entre 0 et 1
    @wave_data = [0.5, 0.6, 0.7, 0.4, 0.2, 0.1, 0.3, 0.5, 0.6, 0.5]
    @wave_data = sample.normalized_data

    # Dessiner l'onde dans le render target
    draw_waveform(args, @wave_data)
    @done = true
  end

  def draw_waveform(args, wave_data)
    waveform = args.render_target(:waveform)
    waveform.background_color = [100, 100, 100]  # Fond noir

    # Position de départ en x
    start_x = 0
    step_x  = waveform.width / (wave_data.length - 1)

    # Centre l'onde verticalement
    center_y      = waveform.height / 1.5
    max_amplitude = waveform.height / 6

    # Dessiner les segments de l'onde
    wave_data.each_cons(2).with_index do |(y1, y2), index|
      x1 = start_x + step_x * index
      x2 = start_x + step_x * (index + 1)
      y1 = center_y + (y1 * max_amplitude) * 2 - max_amplitude
      y2 = center_y + (y2 * max_amplitude) * 2 - max_amplitude
      waveform.lines << [x1, y1, x2, y2, 255, 255, 0]
    end
  end

  def tick_draw(args)
    init_draw(args) unless @done

    # Affiche l'onde sonore à l'écran
    args.outputs.sprites << {
      x: 70,
      y: 550,
      w: 1040,
      h: 100,
      path: :waveform
    }
  end
end
