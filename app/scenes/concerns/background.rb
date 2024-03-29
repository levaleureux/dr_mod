module Concern::Background

  def draw_screen_box
    args.outputs.lines  << [718, 0, 718, 1280]
    args.outputs.lines  << [1, 0, 1, 1280]
    args.outputs.lines  << [0,1, 718, 1]
    args.outputs.lines  << [0,1280, 718, 1280]
    rect = args.layout.rect(row: 0, col: 0, w: 12, h: 24)
    pic  = "sprites/title_bg_001.png"
    pic  = "sprites/anim_00007_pixelate.png"
    args.outputs.sprites << rect.merge({ path: pic })
  end

  def show_text
    sound_info = []
    sound_info <<  "num:    #{@sound.sample.num}"
    sound_info <<  "name:   #{@sound.sample.name}"
    sound_info <<  "length: #{@sound.sample.length}"
    sound_info <<  ""
    sound_info <<  "finetune:      #{@sound.sample.finetune}"
    sound_info <<  "volume:        #{@sound.sample.volume}"
    sound_info <<  "repeat_point:  #{@sound.sample.repeat_point}"
    sound_info <<  "repeat_length: #{@sound.sample.repeat_length}"
    data = @sound.sample.data[0, 20]
    if data.length == 0
      sound_info <<  "data: []"
    else
      sound_info <<  "data: #{@sound.sample.data.size}  [#{data.join(',')}..."
    end
    sound_info.each_with_index do |info, index|
      args.outputs.labels << args.layout.rect(row: 1 + index, col: 1)
        .merge(text: info, vertical_alignment_enum: 1, alignment_enum: 0,
               size_enum: 8)
    end
    args.outputs.labels << args.layout.rect(row: 10, col: 1)
      .merge(text: "sample_rate: #{@sound.sample_rate} custom rate: #{@sound.custom_rate}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
    count = @sound.sample_count
    args.outputs.labels << args.layout.rect(row: 11, col: 1)
      .merge(text: "duration:    #{@sound.custom_duration.to_i}/#{count}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
  end

  def init_dr_mod
    #file_path = "/mygame/sounds/falso_siddo.mod"
    file_path = "/mygame/sounds/alex_menchi_-_xenon_3_miniblast.mod"

    @mod = DrMod.new file_path
    @mod.load_all

    @generate_sine_wave = lambda do
      frequency = 440.0 # A5
      samples_per_period = (@sample_rate / frequency).ceil
      one_period = samples_per_period.map_with_index { |i|
        Math.sin((2 * Math::PI) * (i / samples_per_period))
      }
      one_period * frequency # Generate 1 second worth of sound
    end
    @current_line = 0

  end
end
