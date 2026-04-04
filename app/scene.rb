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
    state.my_scenes[self.class::NAME] = self
  end
end

require "app/scenes/concern.rb"
require "app/scenes/concerns/background.rb"
require "app/scenes/concerns/sound_box.rb"
require "app/scenes/concerns/pattern_box.rb"
require "app/component/pattern_player/pattern_draw.rb"
require "app/component/pattern_player/pattern_side_bar.rb"
require "app/component/pattern_player/pattern_audio.rb"
require "app/component/pattern_player/pattern_tempo.rb"
require "app/component/pattern_player/pattern_input.rb"
require "app/component/pattern_player.rb"

# Scenes are loaded via explicit requires in main.rb.
# Dynamic loading via $gtk.list_files removed for DR 6.x compatibility.
