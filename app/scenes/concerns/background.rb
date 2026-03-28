module Concern::Background

  MOD_FILES = [
    "sounds/falso_siddo.mod",
    "sounds/alex_menchi_-_xenon_3_miniblast.mod"
  ].freeze

  def draw_screen_box
    draw_borders
    draw_background_sprite
  end

  def init_dr_mod
    @mod = DrMod.new MOD_FILES.last
    @mod.load_all
    @current_line = 0
  end

  private

  def draw_borders
    args.outputs.lines << [718,    0, 718, 1280]
    args.outputs.lines << [1,      0,   1, 1280]
    args.outputs.lines << [0,      1, 718,    1]
    args.outputs.lines << [0,   1280, 718, 1280]
  end

  def draw_background_sprite
    rect = args.layout.rect(row: 0, col: 0, w: 12, h: 24)
    args.outputs.sprites << rect.merge(path: "sprites/anim_00007_pixelate.png")
  end
end
