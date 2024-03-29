
class Scene::Title
  include ::Concern::Background
  include ::Concern::SoundBox
  include ::Concern::PatternBox
  attr_gtk
  NAME = :title

  def initialize args
    @x = 100
    @y = 100
    @color = {r: 255, g: 0, b: 0}
    args.state.action = false
    proc_play  = Proc.new { start_game }
    width      = 128
    s_w        = 720
    s_h        = 1280
    init_dr_mod
    @channels = []
    4.times do |channel|
      @channels << SfxPlayer.new(args, @mod, "channel_#{channel}".to_sym)
    end
    @sound = SfxPlayer.new args, @mod, :my_audio
    @patterns_player = PatternPlayer.new args, @mod, @channels
    # play_wav_sound :base_2, "jazz-kick-1"
    @space = :traker
  end

  def tick
    switch_space if args.inputs.keyboard.key_down.c
    if @space == :traker
      @patterns_player.args = args
      @patterns_player.tick
    else
      sound_section
    end
  end

  def switch_space
    if @space == :traker
      @space = :sound_lab
    else
      @space = :traker
    end
  end

  private

  def start_game
    scene_quit
    args.state.next_scene = :level
  end

  def scene_quit
    args.state.action = false
  end

end
