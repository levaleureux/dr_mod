#
# First scene
#
class Scene::Title < Scene
  include ::Concern::Background
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
    switch_scene if args.inputs.keyboard.key_down.s
    tick_current_scene
  end

  private

  def init_scene_elements
    init_dr_mod
    @channels = []
    init_mod_elements
  end

  def init_mod_elements
    4.times do |channel|
      @channels << SfxPlayer.new(args, @mod, "channel_#{channel}".to_sym)
    end
    @sound           = SfxPlayer.new args, @mod, :my_audio
    @patterns_player = PatternPlayer.new args, @mod, @channels
    # play_wav_sound :base_2, "jazz-kick-1"
  end

  def switch_scene
    scene_quit
    args.state.next_scene = :sample
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
    post_init unless @post_init
    @patterns_player.args = args
    @patterns_player.tick
  end

  def post_init
    args.state.current_samples = @sound
    puts args.state.current_samples
    puts "post init --------------------------------"
    @post_init = true
  end
end
