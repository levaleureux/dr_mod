module Concern::Background

  #
  # TODO is outputs part of gtk_args
  #
  def draw_screen_box
    args.outputs.lines  << [718,    0, 718, 1280]
    args.outputs.lines  << [1,      0,   1, 1280]
    args.outputs.lines  << [0,      1, 718,    1]
    args.outputs.lines  << [0,   1280, 718, 1280]
    #
    rect = args.layout.rect(row: 0, col: 0, w: 12, h: 24)
    pic  = "sprites/title_bg_001.png"
    pic  = "sprites/anim_00007_pixelate.png"
    args.outputs.sprites << rect.merge({ path: pic })
  end

  def init_dr_mod
    #file_path = "/mygame/sounds/falso_siddo.mod"
    file_path = "/mygame/sounds/alex_menchi_-_xenon_3_miniblast.mod"
    file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"

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
