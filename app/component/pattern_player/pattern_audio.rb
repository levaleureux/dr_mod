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
    return if cell.sample_number == 0
    return unless @with_sound
    play_mod_sample num, cell
  end

  # ProTracker samples are 1-indexed (0 = no instrument).
  # Ruby array is 0-indexed, so subtract 1.
  def play_mod_sample num, cell
    s = @mod.samples[cell.sample_number - 1]
    rate = amiga_rate cell.note_period, s.finetune
    sound = one_shot_lambda s
    play_on_channel num, rate, sound, s
  end

  # Volume 0-64 mapped to gain 0.0-1.0
  def play_on_channel num, rate, sound, s
    args.audio["channel_#{num}".to_sym] = {
      input: [1, rate, sound],
      gain: s.volume / 64.0
    }
  end

  # Convert Amiga period to playback rate in Hz.
  # Finetune adjusts pitch by ±1/8 semitone per step.
  # Formula: hz = PAL_FREQ / (period * 2) * 2^(finetune/96)
  # 96 = 12 semitones × 8 finetune steps per semitone.
  def amiga_rate period, finetune = 0
    base = SfxPlayer::AMIGA_PAL_FREQ / (period * 2)
    (base * finetune_factor(finetune)).to_i
  end

  def finetune_factor finetune
    2 ** (finetune / 96.0)
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
