# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("_death_race_.mod")
#
#
# https://www.lim.di.unimi.it/IEEE/VROS/FAQ/CRAMIG2.HTM
#
# TODO create a folder core with subcore folders
# TODO rename dr_mod_tracker into dr_mod
#
require "lib/dr_mod_tracker/tracker_formats/protracker_1_1_b.rb"
require "lib/dr_mod_tracker/sample/sample_print.rb"
require "lib/dr_mod_tracker/dr_binary_file.rb"
require "lib/dr_mod_tracker/load_tool.rb"
require "lib/dr_mod_tracker/sample.rb"
require "lib/dr_mod_tracker/samples_loader.rb"
require "lib/dr_mod_tracker/song/song_setup.rb"
require "lib/dr_mod_tracker/song/song_print.rb"
require "lib/dr_mod_tracker/song.rb"
require "lib/dr_mod_tracker/cell/cell_bin.rb"
require "lib/dr_mod_tracker/cell.rb"
require "lib/dr_mod_tracker/pattern/pattern_print.rb"
require "lib/dr_mod_tracker/pattern.rb"

#
# The main class of the lib
#
class DrMod
  #attr_accessor :song, :samples, :patterns
  attr_reader :song, :samples, :patterns

  def initialize file_path
    # TODO must raise if no file
    #
    file_stat = $gtk.stat_file file_path
    if file_stat == nil
      raise "file not found: #{file_path}"
    end
    @mod_data = $gtk.read_file file_path
  end

  def puts_mod_data
    puts @mod_data
  end

  def load_all
    puts_title "Song data"
    @song = Song.new @mod_data
    @song.puts_info
    load_samples
    load_all_2nd_part
  end

  def puts_title title
    # puts "--------------------------------------------"
    puts " #{title}"
    puts "--------------------------------------------"
  end

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

  private

  # TODO the split and puts title show there is something wrong
  #
  def load_samples
    puts_title "Samples list"
    samples_loader = SamplesLoader.new @mod_data, @song
    @samples       = samples_loader.load
    samples_loader.puts_sample_info
  end

  def load_all_2nd_part
    puts_title "Pattern list"
    load_patterns
    #puts_title "Samples data"
    #load_samples_data
    @samples.map &:puts_info_data
  end

end
