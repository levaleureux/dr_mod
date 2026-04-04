module CellInfo

  def info_verbose
    [ "Sample Number: #{@sample_number},  ",
      "Note Period: #{@note_period}, ",
      "Effect Command: #{@effect_command}, ",
      "Effect Argument: #{@effect_argument}" ]
  end

  def info
    note = @note_period == 0 ? "   " : LoadTool::T_SPEC[:notes][@note_period]
    note = note == "" ? "blk" : note
    format_data(note).join("\u2503")
  end

  private

  def info_effect val
    val == 0 ? "   " : format('%03d', val)
  end

  def format_data note
    [ format('%02d', @sample_number),
      note,
      info_effect(@effect_command),
      info_effect(@effect_argument) ]
  end
end
