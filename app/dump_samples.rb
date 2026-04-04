# Dump sample properties for comparison with XMP/MilkyTracker
# Usage: ../../dragonruby-macos/dragonruby projects/dr_mod --eval app/dump_samples.rb --no-tick
#
require 'lib/dr_mod_tracker/dr_mod.rb'

file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"
mod = DrMod.new file_path
mod.load_all

puts "=== dr_mod sample dump ==="
puts "Module: #{mod.song.name}"
puts ""
puts format("%-4s %-24s %4s %6s %4s %6s %6s",
  "Num", "Name", "Vol", "Length", "Fine", "RepPt", "RepLen")
puts "-" * 60

mod.samples.each_with_index do |sample, index|
  puts format("%-4d %-24s %4d %6d %4d %6d %6d",
    index,
    sample.name.to_s.strip,
    sample.volume,
    sample.length,
    sample.finetune,
    sample.repeat_point,
    sample.repeat_length)
end
