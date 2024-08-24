#
# Use for log
#
module SamplePrint

  def puts_info
    puts "num:    #{@num}"
    puts "name:   #{@name}"
    puts "length: #{@length}"
    puts_info_before
  end

  def puts_info_data
    puts_info_data_before
    data = @data[0, 20]
    puts_info_data_after data
  end

  private

  def puts_info_before
    puts ""
    puts "finetune:      #{@finetune}"
    puts "volume:        #{@volume}"
    puts "repeat_point:  #{@repeat_point}"
    puts "repeat_length: #{@repeat_length}"
  end

  def puts_info_data_before
    puts "----------------------"
    puts "num:      #{@num}"
    puts "name:     #{@name}"
    puts "length:   #{@length}"
    puts "finetune: #{@finetune}<-"
  end

  def puts_info_data_after data
    if data.empty? # length == 0
      puts "data: []"
    else
      puts "data:   [#{data.join(',')}..."
    end
  end

end
