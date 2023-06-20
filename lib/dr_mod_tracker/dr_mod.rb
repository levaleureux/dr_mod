# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("_death_race_.mod")
#
#
# https://www.lim.di.unimi.it/IEEE/VROS/FAQ/CRAMIG2.HTM
require "lib/dr_mod_tracker/tracker_formats/protracker_1_1_b.rb"
require "lib/dr_mod_tracker/load_tool.rb"
require "lib/dr_mod_tracker/sample.rb"
require "lib/dr_mod_tracker/song.rb"
require "lib/dr_mod_tracker/pattern.rb"

class DrMod
  attr_accessor :song, :samples, :patterns

  def initialize file_path
    @mod_data = $gtk.read_file file_path
    #puts_mod_data
  end

  def puts_mod_data
    puts @mod_data
  end

  def load_all
    puts "--------------------------------------------"
    puts " Song data"
    puts "--------------------------------------------"
    @song = Song.new @mod_data
    @song.puts_info
    puts "--------------------------------------------"
    puts " Samples list sisis"
    puts "--------------------------------------------"
    load_samples
    puts "--------------------------------------------"
    puts " pattern list"
    puts "--------------------------------------------"
    load_patterns
    puts "--------------------------------------------"
    puts " samples data "
    puts "--------------------------------------------"
    load_samples_data
    @samples.map &:puts_info_data
  end
  #
  #
  #
  def load_samples
    @samples = []
    32.times do |sample_num|
      @samples.push Sample.new sample_num, @mod_data
    end
    #sample_1 = @samples.first
    #sample_1.puts_info
    @samples.each do |sample|
      puts "=========------------========______========="
      sample.puts_info
    end
  end

  #
  #
  #
  def load_patterns
    #4.times do |pattern_num|
    @patterns = []
    @song.pattern_count.times do |pattern_num|
      #puts "------------"
      @patterns << Pattern.new(@mod_data, pattern_num)
      #pattern.puts_info
    end
    #@patterns.map &:puts_info
  end

  def load_samples_data
    #@song.samples_count.times do |sample_num|
    @cumulative_offset = 0
    @samples.each do |sample|
      offset = @song.samples_start_at + @cumulative_offset
      sample.decode_data offset
      @cumulative_offset += sample.length
    end
  end
end
