module PatternPlayerSideBar
  attr_gtk
  #attr_accessor :sample_count, :duration, :sample_rate

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
    args.outputs.labels << args.layout.rect(row: (-9), col: 18)
      .merge(text: "Channels space : press S",
             vertical_alignment_enum: 0, alignment_enum: 0,
             size_enum: 1)
    args.outputs.labels << args.layout.rect(row: (-8), col: 18)
      .merge(text: "Toggle play : Spacebar",
             vertical_alignment_enum: 0, alignment_enum: 0,
             size_enum: 1)
    # sound_info <<  ""
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

end
