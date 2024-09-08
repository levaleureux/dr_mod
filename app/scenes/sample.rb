#
# Scene dedicated to sample work
#
class Scene::Sample < Scene
  include KeyboardSample
  include RenderSample

  attr_gtk
  NAME = :sample

  def initialize args
    @sound              = SfxPlayer.new args, @mod, :my_audio
    @keyboard_mode      = "normal"
    @named_note_periods = PROTRACKER_1_1_B[:notes].invert
  end

  def tick
    switch_space if args.inputs.keyboard.key_down.c
    # NOTE: ???
    if args.state.action == false
      args.state.action = true
      puts args.state.action
    end
    @sound = args.state.current_samples
    show_text
    keyboard_check
  end

  def switch_space
    args.state.next_scene = :title
  end

  private

  def scene_quit
    args.state.action = false
  end

end
