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
    @scene_sample  = Scene::Sample.new args
    # TODO sound scene
    post_init
  end

  #
  # TODO use state directly
  #
  def tick
    state.my_scenes[state.current_scene].tick
    @scene_manager.tick
    # TODO inputs directly ?
    if args.inputs.keyboard.key_down.escape
      # TODO $gtk
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
    [@scene_title, @scene_sample].each do |scene|
      scene.args = args
      scene.add_to_scenes
    end
  end

end
