#
# Loads sample headers and audio data from a MOD file.
#
# ProTracker stores 31 sample headers (bytes 20-949),
# numbered 1-31 in the spec. We store them in a Ruby
# array indexed 0-30.
#
# When patterns reference sample N, use @samples[N - 1].
# Sample 0 in patterns means "no instrument" (see #38).
#
class SamplesLoader
  # ProTracker has exactly 31 sample slots.
  SAMPLE_COUNT = 31

  attr_reader :samples

  def initialize mod_data, song
    @mod_data          = mod_data
    @cumulative_offset = 0
    @samples           = []
    @song              = song
  end

  def load
    load_samples
    load_samples_data
    @samples
  end

  def load_samples
    SAMPLE_COUNT.times do |sample_num|
      @samples.push Sample.new sample_num, @mod_data
    end
  end

  def load_samples_data
    @samples.each_with_index do |sample, index|
      load_single_sample sample, index
    end
  end

  def load_single_sample sample, index
    log_sample_load index
    offset = @song.samples_start_at + @cumulative_offset
    sample.decode_data offset
    @cumulative_offset += sample.length
  end

  private

  def log_sample_load index
    puts "load sample #{index}"
    puts "samples_start_at #{@song.samples_start_at}"
    puts "cumulative_offset #{@cumulative_offset}"
  end

  def puts_sample_info
    @samples.each do |sample|
      puts "=========------------========______========="
      sample.puts_info
    end
  end

end
