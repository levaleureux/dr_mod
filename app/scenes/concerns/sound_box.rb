module Concern::SoundBox
  # TODO rename @sounds or @samples
  def keyboard_check
    @key_down = false
    @sound.args = args
    @sound.tick
    if @keyboard_mode == "normal"

      @sound.select_down if args.inputs.keyboard.key_down.k
      @sound.select_up   if args.inputs.keyboard.key_down.j

      @sound.rate_down if args.inputs.keyboard.key_down.p
      @sound.rate_up   if args.inputs.keyboard.key_down.o
      #
      if args.inputs.keyboard.key_down.y
        @keyboard_mode = "play"
        puts "play"
        @key_down = true
      end
      #
    end
    if @keyboard_mode == "play"
      @sound.stop  if args.inputs.keyboard.key_down.u
      @sound.start if args.inputs.keyboard.key_down.i
      if args.inputs.keyboard.key_down.y && !@key_down
        @keyboard_mode = "normal"
        puts "back normal"
      end
      octave_key_fr
    end
  end

  def octave_key_en
    notes = %w(a b c d e f g)
    notes.each do |note|
      if args.inputs.keyboard.key_down.method(note).call
        puts note.upcase
        @note_name = note.upcase
      end
    end
  end

  def octave_key_fr
    notes = [['d', 'Do'],['r', 'Re'], ['m', 'Mi'],
             ['f', 'Fa'],['s', 'Sol'], ['l', 'La'], ['t', 'Si - Ti']]
    notes.each do |key, note|
      if args.inputs.keyboard.key_down.method(key).call
        @sound.start
        puts note.upcase
        @note_name = note.upcase
      end
    end
  end
end
