require 'lib/dr_mod_tracker/dr_mod.rb'
require "app/ui/layout_config.rb"
require "app/ui/status_bar.rb"
require "app/ui/sidebar_colors.rb"
require "app/ui/sidebar_positions.rb"
require "app/ui/sidebar_channels.rb"
require "app/ui/sidebar_panel.rb"
require "app/scenes/concern.rb"
require "app/scene.rb"
require "app/scenes/scene_manager.rb"
require "app/scenes/game.rb"
require "app/scenes/title.rb"
require "app/scenes/sample.rb"
require "app/component/sfx_player/sfx_draw.rb"
require "app/component/sfx_player.rb"
require "app/component/pattern_player/pattern_draw.rb"
require "app/component/pattern_player/pattern_side_bar.rb"
require "app/component/pattern_player/pattern_audio.rb"
require "app/component/pattern_player/pattern_tempo.rb"
require "app/component/pattern_player/pattern_input.rb"
require "app/component/pattern_player/pattern_state.rb"
require "app/component/pattern_player.rb"
require "app/component/game.rb"

def tick args
  args.state.game ||= Game.new args
  args.state.game.args = args
  # args.state.game.post_init unless args.state.post_init
  args.state.game.tick
  reset_game args if args.inputs.keyboard.key_down.r
end

def reset_game args
  args.state.game = nil
  $gtk.reset
  puts "Game reseted"
end
