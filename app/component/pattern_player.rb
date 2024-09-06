class PatternPlayer
  attr_gtk

  include PatternPlayerSideBar
  #attr_accessor :sample_count, :duration, :sample_rate

  def initialize args, mod, channels
    @args         = args
    @mod          = mod
    @patterns     = mod.patterns
    @channels     = channels
    #
    @current_line    = 5
    @current_pattern = 0
    @color_tonic     = { r: 208, g: 130, b: 130 }
    @playing         = false
    @with_sound      = false
  end

  def tick
    @played_sounds ||= ["", "", "", ""]
    #@current_pattern = 1
    # sound_section
    #if args.tick_count % 7 == 0
    #
    @pattern    = @patterns[@current_pattern]

    #@playing = false
    @with_sound = !@with_sound if args.inputs.keyboard.key_down.m
    @playing = !@playing if args.inputs.keyboard.key_down.space
    @current_line -= 1 if args.inputs.keyboard.key_down.up
    @current_line += 1 if args.inputs.keyboard.key_down.down

    if args.tick_count % 10 == 0 && @playing
      play_row_sounds
      @current_line += 1
    end
    if @current_line < 0
      @current_line = 64
      @current_pattern -= 1
    end
    if @current_line >= 64
      @current_line = 0
      @current_pattern += 1
    end
    # TODO FIX pattern 12 break
    @current_pattern -= 1 if args.inputs.keyboard.key_down.left
    @current_pattern += 1 if args.inputs.keyboard.key_down.right
    @current_pattern = 0 if @current_pattern > 11 # @mod.song.length
    @current_pattern = 11 if @current_pattern < 0  # @mod.song.length
    side_bar
    pattern_section
  end

  def play_row_sounds
    # TODO play mod sounds
    #@channels[0].args = args
    #@channels[0].start
    #@channels[0].stop
    #play_wav_sound :channel_0, "kick-1"
    wav_samples = %w(x_01_Kick A3 B3 C3 E3 jazz-2 jazz-3 kick-1 snare-1.wav F3 G3 treble-1)
    @channels.count.times do |num|
      cell = @pattern.rows[@current_line][num]
      if cell.note_period != 0
        play_wav_sound "channel_#{num}".to_sym, wav_samples[num]
      end
    end
  end

  def play_wav_sound channel, name, attrs = {}
    @gain = 0.05
    params = {input: "sounds/#{name}.wav", gain: @gain }.merge(attrs)
    if @with_sound
      args.audio[channel] = params
    end
  end

  def pattern_section
    color_2nd   = { r: 130, g: 188, b: 130 }
    render_bg_col 3, -71
    render_bg_col 7, 131
    render_current_line 0, color_2nd
    render_current_line 16, color_2nd
    render_current_line 32, color_2nd
    render_current_line 48, color_2nd
    render_current_line @current_line, @color_tonic

    64.times do |line|
      render_line @pattern, line, line
    end
  end

  def render_bg_col col, x_offset
    c = 200
    color_bg = { r: c, g: c, b: c }
    rect = args.layout
      .rect(row: 0, col: col, w: 4, h: 1).merge(**color_bg)
    rect.w += 0
    rect.x += x_offset
    rect.h = 1300 - 16
    rect.y -= 1000 - 22
    args.outputs.solids << rect
  end

  def render_current_line row,color
    rect = args.layout
      .rect(row: 0, col: 1, w: 16, h: 1).merge(**color)
    rect.w += 25
    rect.x -= 3
    rect.h = 20
    rect.y += 640 - row * 20 - 354

    args.outputs.solids << rect

  end

  def render_line pattern, num, row
    line = pattern.row_info num
    rect = args.layout.rect(row: row, col: 1)
    rect.y = 640 - row * 20 + 270
    args.outputs.labels << rect.merge(text: line,
                                      vertical_alignment_enum: 1, alignment_enum: 0,
                                      size_enum: 1)
  end
end
