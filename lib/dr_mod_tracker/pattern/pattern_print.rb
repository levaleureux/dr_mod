#
#
#
#
module PatternPrint

  def puts_info
    puts "Pattern: #{@num}"
    puts_lines
  end

  #
  # TODO this method need comment
  #
  def row_info line_offset
    row        = @rows[line_offset]
    cell_infos = row.map &:info
    text       = cell_infos.join("\u2503")
    line       = "#{format('%02d', line_offset)}  #{text}|"
    line
  end

  def puts_lines
    even = 1
    64.times do |line_offset|
      even *= -1
      puts_row line_offset, @rows[line_offset], even
    end
  end

  def puts_row line_offset, row, even
    cell_infos = row.map &:info
    text       = cell_infos.join("\u2503")
    line       = "#{format('%02d', line_offset)}: #{text}|"
    puts_line_with_color line, line_offset, even
  end

  private

  #
  # NOTE, TODO: as there is lot of argument in this method
  # this indicate that :
  # - PatternPrint should be a "formater, decorator?" class
  # - same can be done as "presenter ?" in a game, music software
  #
  def puts_line_with_color line, line_offset, even
    if (line_offset % 8) == 0
      puts "\e[7m#{line}\e[0m"
    else
      puts (even > 0 ? line : "\e[37m#{line}\e[0m")
    end
    #puts (even > 0 ? line : "\e[43m#{line}\e[0m")
  end
end
