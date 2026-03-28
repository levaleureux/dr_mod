#
# Audio playback for PatternPlayer.
# Plays MOD samples using Amiga period-to-frequency conversion.
#
# TODO: add WAV mode toggle for testing (#29)
#
module PatternAudio

  WAV_SAMPLES = %w(x_01_Kick A3 B3 C3 E3 jazz-2 jazz-3 kick-1 snare-1.wav F3 G3 treble-1).freeze

  private

  def play_row_sounds
    @channels.count.times do |num|
      play_channel_sound num
    end
  end

  def play_channel_sound num
    cell = @pattern.rows[@current_line][num]
    return if cell.note_period == 0
    return unless @with_sound
    play_mod_sample num, cell
  end

  def play_mod_sample num, cell
    s = @mod.samples[cell.sample_number]
    rate = amiga_rate cell.note_period
    sound = one_shot_lambda s
    args.audio["channel_#{num}".to_sym] = { input: [1, rate, sound] }
  end

  def amiga_rate period
    (SfxPlayer::AMIGA_PAL_FREQ / (period * 2)).to_i
  end

  def one_shot_lambda s
    played = false
    lambda { played ? [] : (played = true; s.normalized_data) }
  end

  def play_wav_sound channel, name
    return unless @with_sound
    args.audio[channel] = { input: "sounds/#{name}.wav", gain: 0.05 }
  end
end
