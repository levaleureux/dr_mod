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
    @sound.stop  if args.inputs.keyboard.key_down.u
    @sound.start if args.inputs.keyboard.key_down.i
  end

  def handle_navigation_keys
    @sound.select_down if args.inputs.keyboard.key_down.k
    @sound.select_up   if args.inputs.keyboard.key_down.j
    @sound.rate_down   if args.inputs.keyboard.key_down.p
    @sound.rate_up     if args.inputs.keyboard.key_down.o
  end

  # FR keyboard layout for octave keys (see #22 for other layouts)
  def octave_key_fr
    notes_fr.each do |key, note|
      if args.inputs.keyboard.key_down.method(key).call
        @note_name = note.upcase
      end
    end
  end

  def notes_fr
    [['d', 'Do'], ['r', 'Re'], ['m', 'Mi'],
     ['f', 'Fa'], ['s', 'Sol'], ['l', 'La'],
     ['t', 'Si - Ti']]
  end

  # EN keyboard layout — not yet wired, see #22
  def octave_key_en
    notes_en.each do |note|
      if args.inputs.keyboard.key_down.method(note).call
        @note_name = note.upcase
      end
    end
  end

  def notes_en
    %w(a b c d e f g)
  end
end
