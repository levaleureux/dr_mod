#
# State exposure for PatternPlayer.
# Provides hashes for StatusBar and SidebarPanel.
#
module PatternState

  def status_info
    { mod_name: @mod.song.name.strip,
      pattern: @current_pattern,
      line: @current_line,
      total_patterns: @mod.song.length,
      speed: @speed, bpm: @bpm }
  end

  def sidebar_info
    sidebar_toggle_state.merge(sidebar_song_state)
  end

  private

  def sidebar_toggle_state
    { loop: @loop_pattern, sound: @with_sound,
      muted: @muted_channels, played_sounds: @played_sounds }
  end

  def sidebar_song_state
    { current_pattern: @current_pattern,
      total_patterns: @mod.song.length,
      song_positions: song_positions_slice }
  end

  def song_positions_slice
    len = @mod.song.length
    @mod.song.song_positions[0, len]
  end
end
