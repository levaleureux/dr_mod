#
# First scene
#
class Scene::Title < Scene
  include ::Concern::Background
  include ::Concern::SoundBox
  include ::Concern::PatternBox
  attr_gtk
  NAME = :title

  def initialize args
    @x                = 100
    @y                = 100
    @color            = {r: 255, g: 0, b: 0}
    args.state.action = false
    proc_play         = Proc.new { start_game }
    init_scene_elements
  end

  def tick
    switch_space if args.inputs.keyboard.key_down.c
    tick_current_scene
  end

  def switch_space
    if @space == :traker
      @space = :sound_lab
    else
      @space = :traker
    end
  end

  private

  def init_scene_elements
    init_dr_mod
    @channels = []
    init_mod_elements
    @space = :traker
  end

  def init_mod_elements
    4.times do |channel|
      @channels << SfxPlayer.new(args, @mod, "channel_#{channel}".to_sym)
    end
    @sound           = SfxPlayer.new args, @mod, :my_audio
    @patterns_player = PatternPlayer.new args, @mod, @channels
    # play_wav_sound :base_2, "jazz-kick-1"
  end

  def start_game
    scene_quit
    args.state.next_scene = :level
  end

  def scene_quit
    args.state.action = false
  end

  #
  # TODO must use a scene manage patter
  #
  def tick_current_scene
    if @space == :traker
      @patterns_player.args = args; @patterns_player.tick
    else
      sound_section
    end
  end

end
