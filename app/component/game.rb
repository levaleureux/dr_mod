#
# Main game loop. Renders scenes and status bar.
#
class Game
  attr_gtk

  def initialize args
    self.args   = args
    init_components args
    post_init
  end

  def tick
    current_scene.tick
    @scene_manager.tick
    draw_sidebar
    draw_status_bar
    handle_quit
  end

  private

  def init_components args
    @scene_manager = SceneManager.new args
    @scene_title   = Scene::Title.new args
    @scene_sample  = Scene::Sample.new args
    @status_bar    = StatusBar.new
    @sidebar       = SidebarPanel.new
  end

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

  def current_scene
    state.my_scenes[state.current_scene]
  end

  def draw_sidebar
    @sidebar.args = args
    scene = current_scene
    ctx = scene.respond_to?(:sidebar_context) ? scene.sidebar_context : {}
    @sidebar.tick ctx
  end

  def draw_status_bar
    @status_bar.args = args
    @status_bar.tick status_context
  end

  # Build context hash from current scene.
  def status_context
    base = { mode: state.current_scene }
    scene = current_scene
    return base unless scene.respond_to?(:status_context)
    base.merge(scene.status_context)
  end

  def handle_quit
    return unless args.inputs.keyboard.key_down.escape
    args.gtk.request_quit
  end
end
