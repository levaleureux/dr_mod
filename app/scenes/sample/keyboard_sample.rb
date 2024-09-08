module KeyboardSample
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
      if args.inputs.keyboard.key_down.p
        @keyboard_mode = "play"
        puts "play"
        @key_down = true
      end
      #
    end
    if @keyboard_mode == "play"
      # @sound.start if args.inputs.keyboard.key_down.i
      @sound.stop  if args.inputs.keyboard.key_down.u
      if args.inputs.keyboard.key_down.escape && !@key_down
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
    notes = [['d', 'Do','C-1'],['r', 'Re', 'D-1'], ['m', 'Mi', 'E-1'],
             ['f', 'Fa', 'F-1'],['s', 'Sol', 'G-1'], ['l', 'La', 'A-1'], ['t', 'Si - Ti', 'B-1']]
    notes.each { |key, note, code|
      if args.inputs.keyboard.key_down.method(key).call
        # @sound.start
        puts note
        puts code
        note_period = @named_note_periods[code]
        @sound.play_sound note_period
        @note_name = note.upcase
      end
    }
  end
end
