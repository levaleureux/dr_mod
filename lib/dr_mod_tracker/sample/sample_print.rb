module SamplePrint

  def puts_info
    puts "num:    #{@num}"
    puts "name:   #{@name}"
    puts "length: #{@length}"
    puts_info_2
  end

  def puts_info_data
    puts_info_data_1
    data = @data[0, 20]
    puts_info_data_2 data
  end

  private

  def puts_info_2
    puts ""
    puts "finetune:      #{@finetune}"
    puts "volume:        #{@volume}"
    puts "repeat_point:  #{@repeat_point}"
    puts "repeat_length: #{@repeat_length}"
  end

  def puts_info_data_1
    puts "----------------------"
    puts "num:      #{@num}"
    puts "name:     #{@name}"
    puts "length:   #{@length}"
    puts "finetune: #{@finetune}<-"
  end

  def puts_info_data_2 data
    if data.empty? # length == 0
      puts "data: []"
    else
      puts "data:   [#{data.join(',')}..."
    end
  end

end
