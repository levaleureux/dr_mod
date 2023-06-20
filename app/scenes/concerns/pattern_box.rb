module Concern::PatternBox
end

class PatternPlayer
  attr_gtk
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

  def side_bar
    args.outputs.labels << args.layout.rect(row: -8, col: -3)
      .merge(text: "GoodEnoughTraker",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 16)
    #
    # .merge(text: "« 枯れた技術の水平思考 » « La pensée latérale des technologies désuètes » Gunpei Yokoi",
    args.outputs.labels << args.layout.rect(row: -7, col: -2)
      .merge(text: "« 枯れた技術の水平思考 » ",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 1)
    args.outputs.labels << args.layout.rect(row: -1, col: 18)
      .merge(text: "pattern box",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)

    text = []
    @pattern.rows[@current_line].each_with_index do |cell, index|
      if cell.note_period == 0
        #text[index] = ""
      else
        num = cell.sample_number
        @played_sounds[index] = "#{cell.note_period} : #{num} #{@mod.samples[num].name}"
      end
    end
    #args.outputs.labels << args.layout.rect(row: (-6), col: 18)
    #  .merge(text: "Last sounds played no channel",
    #         vertical_alignment_enum: 1, alignment_enum: 0,
    #         size_enum: 1)
    @played_sounds.each_with_index do |info, index|
      args.outputs.labels << args.layout.rect(row: (-5 + index), col: 18)
        .merge(text: "Chanel #{index} : #{info}",
               vertical_alignment_enum: 1, alignment_enum: 0,
               size_enum: 1)
    end

    args.outputs.labels << args.layout.rect(row: 1, col: 18)
      .merge(text: "song positions - Pattern : #{@current_pattern}/#{@mod.song.length}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 1)
    rect = args.layout.rect(row: 3, col: 18, w: 4, h: 1)
    y_step = 22
    rect.x += 0
    rect_2 = rect.clone
    rect_2.y += - 31 - @current_pattern * y_step
    rect_2.h += - 25
    rect_2.w -= 52
    rect_2.x -= 20
    args.outputs.solids << rect_2.merge(**@color_tonic)
    @mod.song.length.times do |pos|
      pattern_num = @mod.song.song_positions[pos]
      rect.y -= y_step
      pos_text = format('%02d', pos + 1)
      args.outputs.labels << rect.merge(text: "#{pos_text} #{pattern_num}",
                                        vertical_alignment_enum: 1, alignment_enum: 0,
                                        size_enum: 1)

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
