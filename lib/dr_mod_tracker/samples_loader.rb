#
# Load
#
class SamplesLoader
  attr_reader :samples

  def initialize mod_data
    @mod_data          = mod_data
    @cumulative_offset = 0
    @samples           = []
  end

  def load
    load_samples
    load_samples_data
    @samples
  end

  def load_samples
    32.times do |sample_num|
      @samples.push Sample.new sample_num, @mod_data
    end
    #puts_sample_info
  end

  def load_samples_data
    @samples.each do |sample|
      offset = @song.samples_start_at + @cumulative_offset
      sample.decode_data offset
      @cumulative_offset += sample.length
    end
  end

  private

  def puts_sample_info
    @samples.each do |sample|
      puts "=========------------========______========="
      sample.puts_info
    end
  end

end
