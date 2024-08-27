module Concern::SoundBox
  # TODO rename @sounds or @samples
  def sound_section
    @sound.args = args
    @sound.tick
    @sound.stop  if args.inputs.keyboard.key_down.u
    @sound.start if args.inputs.keyboard.key_down.i

    @sound.select_down if args.inputs.keyboard.key_down.k
    @sound.select_up   if args.inputs.keyboard.key_down.j

    @sound.rate_down if args.inputs.keyboard.key_down.p
    @sound.rate_up   if args.inputs.keyboard.key_down.o
    show_text
  end
end
