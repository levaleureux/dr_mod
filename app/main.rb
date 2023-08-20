require 'lib/dr_mod_tracker/dr_mod.rb'
require "app/scenes/concern.rb"
require "app/scene.rb"
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
