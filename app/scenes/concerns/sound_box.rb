#
# Concern for sample playback and keyboard controls.
# Handles play/stop, sample navigation, rate adjustment
# and octave keys.
#
# Currently uses FR layout. EN and BEPO layouts planned (see #22).
#
module Concern::SoundBox

  def sound_section
    @sound.args = args
    @sound.tick
    handle_playback_keys
    handle_navigation_keys
    octave_key_fr
  end

  private

  def handle_playback_keys
    keys = args.inputs.keyboard.key_down
    @sound.stop  if keys.u
    @sound.start if keys.i
  end

  def handle_navigation_keys
    keys = args.inputs.keyboard.key_down
    @sound.select_down if keys.k
    @sound.select_up   if keys.j
    @sound.rate_down   if keys.p
    @sound.rate_up     if keys.o
  end

  # FR keyboard layout for octave keys (see #22 for other layouts)
  def octave_key_fr
    keys = args.inputs.keyboard.key_down
    notes_fr.each do |key, note|
      @note_name = note.upcase if keys.method(key).call
    end
  end

  def notes_fr
    [['d', 'Do'], ['r', 'Re'], ['m', 'Mi'],
     ['f', 'Fa'], ['s', 'Sol'], ['l', 'La'],
     ['t', 'Si - Ti']]
  end

  # EN keyboard layout — not yet wired, see #22
  def octave_key_en
    keys = args.inputs.keyboard.key_down
    notes_en.each do |note|
      @note_name = note.upcase if keys.method(note).call
    end
  end

  def notes_en
    %w(a b c d e f g)
  end
end
