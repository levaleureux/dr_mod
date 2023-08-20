#
# Where there is the main loop
#
class Game
  attr_gtk

  # TODO move scene in scene manager
  def initialize args
    self.args      = args
    @scene_manager = SceneManager.new args
    @scene_title   = Scene::Title.new args
    post_init
  end

  #
  # TODO use state directly
  #
  def tick
    args.state.my_scenes[args.state.current_scene].tick
    @scene_manager.tick
    if args.inputs.keyboard.key_down.escape
      args.gtk.request_quit
    end
  end

  private

  def post_init
    @scene_manager.args = args
    state.my_scenes = {}
    post_init_scenes

    state.post_init = true
  end

  def post_init_scenes
    [@scene_title].each do |scene|
      scene.args = args
      scene.add_to_scenes
    end
  end

end
