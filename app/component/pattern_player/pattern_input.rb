#
# Keyboard input handling for PatternPlayer.
# Toggle keys, navigation, and channel mute.
#
module PatternInput

  private

  def handle_input
    handle_toggle_keys
    handle_navigation_keys
  end

  def handle_toggle_keys
    keys = args.inputs.keyboard.key_down
    @with_sound = !@with_sound if keys.m
    @playing = !@playing if keys.space
    @loop_pattern = !@loop_pattern if keys.l
    toggle_channels
  end

  # Keys 1-4 mute/unmute individual channels.
  def toggle_channels
    4.times do |ch|
      toggle_channel ch if channel_key_down?(ch)
    end
  end

  def channel_key_down? ch
    keys = args.inputs.keyboard.key_down
    keys.send("#{ch + 1}")
  end

  def toggle_channel ch
    @muted_channels[ch] = !@muted_channels[ch]
  end

  def handle_navigation_keys
    keys = args.inputs.keyboard.key_down
    @current_line -= 1 if keys.up
    @current_line += 1 if keys.down
    @current_pattern -= 1 if keys.left
    @current_pattern += 1 if keys.right
  end
end
