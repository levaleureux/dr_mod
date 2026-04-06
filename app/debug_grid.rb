# Debug script: dump all grid/window properties
# Run: copy to mygame/ in DR 6.51 SDK then launch
#
# Looking for physical window size API for responsive text.
#
puts "=== Grid Properties ==="
grid = $gtk.args.grid
grid.to_hash.each do |key, val|
  next if val.is_a?(Hash) || val.is_a?(Array)
  puts "grid.#{key} = #{val}"
end

puts ""
puts "=== GTK Properties ==="
%w(window_w window_h logical_w logical_h).each do |prop|
  val = $gtk.respond_to?(prop) ? $gtk.send(prop) : "N/A"
  puts "$gtk.#{prop} = #{val}"
end

puts ""
puts "=== Args Properties ==="
%w(render_w render_h).each do |prop|
  val = $gtk.args.respond_to?(prop) ? $gtk.args.send(prop) : "N/A"
  puts "args.#{prop} = #{val}"
end
