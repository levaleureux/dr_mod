require "./dr_mod.rb"

if ARGV.empty?
  puts "Veuillez spécifier le chemin vers votre fichier MOD en tant qu'argument du script."
else
  file_path = ARGV[0]
  mod = DrMod.new file_path
  mod.load_all
end
puts "Done Mr ! we load a mod"
