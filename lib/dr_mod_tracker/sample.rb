#
#
#
#
class Sample
  include LoadTool
  ATTR_LIST = %i(num s_offset name length finetune volume repeat_point repeat_length data normalized_data)
  attr_accessor *ATTR_LIST

  def initialize num, mod_data
    @num      = num
    @s_offset = num * 30
    @mod_data = mod_data
    set_name
    set_length
    set_finetune
    set_volume
    set_repeat_point
    set_repeat_length
  end

  def set_name
    @name = set_attr :sample_name
  end

  # it's an amiga word
  #
  def set_length
    offset = T_SPEC[:sample_length][:offset] + @s_offset
    @length = decode_amiga_word @mod_data, offset
  end

  def set_finetune
    offset    = T_SPEC[:finetune][:offset] + @s_offset
    size      = T_SPEC[:finetune][:bytes]
    @finetune = @mod_data[offset, size].unpack("C").first
    #@finetune = set_attr :finetune
  end

  def set_volume
    offset      = T_SPEC[:volume][:offset] + @s_offset
    size        = T_SPEC[:volume][:bytes]
    volume_byte = @mod_data[offset, size].unpack("C").first
    #@volume     = (volume_byte & 0x7F) / 2
    @volume     = volume_byte # % 65
  end

  def set_repeat_point
    offset = T_SPEC[:repeat_point][:offset] + @s_offset
    #@repeat_point = @mod_data[offset, 2].unpack("S>").first
    @repeat_point = decode_amiga_word @mod_data, offset
  end

  def set_repeat_length
    offset = T_SPEC[:repeat_length][:offset] + @s_offset
    @repeat_length = decode_amiga_word @mod_data, offset
  end

  def set_attr attr_name
    offset = T_SPEC[attr_name][:offset] + @s_offset
    size   = T_SPEC[attr_name][:bytes]
    @mod_data[offset, size]
  end

  def decode_data offset
    @data = @mod_data[offset..(offset + @length - 1)].unpack("C*")
    normalized
  end

  #
  # Point 2 : Conversion des données d'échantillon
  # en un tableau de valeurs flottantes entre -1.0 et 1.0
  #
  def normalized
    @normalized_data = @data.map do |value|
      #(value - 128.0) / 128.0
      normalize_value value
    end

  end

  def normalize_value value
    if value < 128
      value = value / 128.0
    else
      value = ((value - 128) / 128.0) - 1.0
    end
  end

  def puts_info
    puts "num:    #{@num}"
    puts "name:   #{@name}"
    puts "length: #{@length}"
    puts ""
    puts "finetune:      #{@finetune}"
    puts "volume:        #{@volume}"
    puts "repeat_point:  #{@repeat_point}"
    puts "repeat_length: #{@repeat_length}"
  end

  def puts_info_data
    puts "----------------------"
    puts "num:      #{@num}"
    puts "name:     #{@name}"
    puts "length:   #{@length}"
    puts "finetune: #{@finetune}<-"
    data = @data[0, 20]
    if data.length == 0
      puts "data: []"
    else
      puts "data:   [#{data.join(',')}..."
    end
  end
end
