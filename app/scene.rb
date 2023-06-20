require "app/scenes/concern.rb"
require "app/scenes/concerns/background.rb"
require "app/scenes/concerns/sound_box.rb"
require "app/scenes/concerns/pattern_box.rb"

def load_dep_files path
  $gtk.list_files(path).each do |f|
    require File.join(path, f)
  end
end

load_dep_files "app/scenes"

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

end
