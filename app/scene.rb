require "app/scenes/concern.rb"
require "app/scenes/concerns/background.rb"
require "app/scenes/concerns/sound_box.rb"
require "app/scenes/concerns/pattern_box.rb"

def load_dep_files path
  $gtk.list_files(path).each do |ffile|
    require File.join(path, file)
  end
end

load_dep_files "app/scenes"

# Base of scenes class
#
class Scene

  def color_btn
    @color_btn ||= { r: 228, g: 128, b: 150 }
  end

  def color_cell
    @color_btn ||= { r: 228, g: 128, b: 150 }
  end

  def color_header
    @color_header ||= { r: 228, g: 150, b: 100 }
  end

  def add_to_scenes
    puts self.class::NAME
    state.my_scenes[scene.class::NAME] = self
  end
end
