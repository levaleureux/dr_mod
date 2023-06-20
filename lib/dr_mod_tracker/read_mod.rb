def read_mod_file(file_path)
  File.open(file_path, "rb") do |file|
    # Lecture de l'en-tête du fichier MOD
    file.read(20) # Ignorer les premiers octets non nécessaires
    # Lecture des séquences de notes
    note_sequences = []
    31.times do
      sequence = file.read(4) # Lecture d'une séquence de 4 octets
      note_sequences << sequence
    end

    #                                     # Affichage des séquences de notes
    note_sequences.each_with_index do |sequence, index|
      puts "Channel #{index + 1}: #{sequence.unpack('C*').join(' ')}"
    end
  end
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("_death_race_.mod")

def read_mod_file_2(file_path)
  mod_data = File.binread(file_path)

  # Lecture de l'en-tête du fichier MOD
  song_length = mod_data.getbyte(950)
  pattern_order_table = mod_data[952..1083]

  pattern_data_offset = 1084

  # Parcours de la table d'ordre des patterns
  pattern_order_table.each_byte do |pattern_index|
    pattern_offset = pattern_data_offset + pattern_index * 1024

    # Lecture des notes du pattern
    pattern_data = mod_data[pattern_offset, 1024]

    # Parcours des notes du pattern
    pattern_data.each_byte do |note_byte|
      note = note_byte & 0x0F
      sample = (note_byte & 0xF0) >> 4

      # Affichage de la note et de l'échantillon correspondants
      puts "Note: #{note}, Sample: #{sample}"
    end
  end
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file_2("_death_race_.mod")

def read_mod_file_3(file_path)
  mod_data = File.binread(file_path)

  # Lecture de l'en-tête du fichier MOD
  song_length = mod_data.getbyte(950)
  pattern_order_table = mod_data[952..1083]

  pattern_data_offset = 1084

  # Parcours de la table d'ordre des patterns
  pattern_order_table.each_byte do |pattern_index|
    pattern_offset = pattern_data_offset + pattern_index * 1024

    # Lecture des notes du pattern
    pattern_data = mod_data[pattern_offset, 1024]

    # Parcours des notes du pattern par canal (4 canaux au total)
    (0..3).each do |channel_index|
      channel_offset = channel_index * 256

      puts "Canal #{channel_index + 1}:"

      # Affichage des notes et échantillons par ligne
      pattern_data[channel_offset, 256].each_byte.with_index do |note_byte, note_index|
        if note_index % 16 == 0 && note_index != 0
          puts
        end

        note = note_byte & 0x0F
        sample = (note_byte & 0xF0) >> 4

        line_index = note_index / 16
        print "Ligne #{line_index + 1}: Note: #{note}, Sample: #{sample} | "
      end

      puts "\n\n"
    end
  end
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file_3("_death_race_.mod")

def read_mod_file(file_path)
  mod_data = File.binread(file_path)

  # Lecture de l'en-tête du fichier MOD
  song_length = mod_data.getbyte(950)
  pattern_order_table = mod_data[952..1083]

  pattern_data_offset = 1084

  # Parcours de la table d'ordre des patterns
  pattern_order_table.each_byte do |pattern_index|
    pattern_offset = pattern_data_offset + pattern_index * 1024

    # Lecture des notes du pattern
    pattern_data = mod_data[pattern_offset, 1024]

    # Affichage des lignes vides entre les patterns
    puts "\n\n"

    # Parcours des lignes du pattern
    (0..63).each do |line_index|
      line_offset = line_index * 16

      # Affichage des notes et échantillons par ligne
      puts "Ligne #{line_index + 1}: " + pattern_data[line_offset, 4].unpack("C*").map { |note_byte| "#{note_byte & 0x0F}/#{(note_byte & 0xF0) >> 4}"  }.join("  ")
    end
  end
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("_death_race_.mod")

def read_mod_file(file_path)
  mod_data = File.binread(file_path)

  # Lecture de l'en-tête du fichier MOD
  song_length = mod_data.getbyte(950)
  pattern_order_table = mod_data[952..1083]

  pattern_data_offset = 1084

  # Parcours de la table d'ordre des patterns
  pattern_order_table.each_byte do |pattern_index|
    pattern_offset = pattern_data_offset + pattern_index * 1024

    # Lecture des notes du pattern
    pattern_data = mod_data[pattern_offset, 1024]

    # Affichage des lignes vides entre les patterns
    puts "\n\n"

    # Parcours des lignes du pattern
    (0..63).each do |line_index|
      line_offset = line_index * 16

      # Affichage des informations de chaque note par ligne
      puts "Ligne #{line_index + 1}:"
      4.times do |channel|
        note_byte = pattern_data[line_offset + channel]
        note = note_byte & 0x0F
        sample = (note_byte & 0xF0) >> 4
        effect_byte = pattern_data[line_offset + 8 + channel]
        effect = effect_byte & 0x0F
        effect_param = (effect_byte & 0xF0) >> 4

        puts "  Canal #{channel + 1}: Note: #{note}, Échantillon: #{sample}, Effet: #{effect}, Paramètre: #{effect_param}"
      end
    end
  end
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("_death_race_.mod")

def read_mod_file(file_path)
  mod_data = File.binread(file_path)

  # Lecture de l'en-tête du fichier MOD
  song_length = mod_data.getbyte(950)
  pattern_order_table = mod_data[952..1083]

  pattern_data_offset = 1084

  # Parcours de la table d'ordre des patterns
  pattern_order_table.each_byte do |pattern_index|
    pattern_offset = pattern_data_offset + pattern_index * 1024

    # Lecture des notes du pattern
    pattern_data = mod_data[pattern_offset, 1024]

    # Affichage des lignes vides entre les patterns
    puts "\n\n"

    # Parcours des lignes du pattern
    (0..63).each do |line_index|
      line_offset = line_index * 16

      # Affichage des informations de chaque note par ligne
      puts "Ligne #{line_index + 1}:"
      4.times do |channel|
        note_byte = pattern_data[line_offset + channel].unpack("C").first
        note = note_byte & 0x0F
        sample = (note_byte & 0xF0) >> 4
        effect_byte = pattern_data[line_offset + 8 + channel].unpack("C").first
        effect = effect_byte & 0x0F
        effect_param = (effect_byte & 0xF0) >> 4

        puts "  Canal #{channel + 1}: Note: #{note}, Échantillon: #{sample}, Effet: #{effect}, Paramètre: #{effect_param}"
      end
    end
  end
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("_death_race_.mod")
def read_mod_file_header(file_path)
  #mod_data = File.binread(file_path, encoding: 'ASCII-8BIT')
  mod_data = File.binread(file_path)

  # Lecture des informations de l'en-tête
  module_name = mod_data[0..19].rstrip
  number_of_channels = mod_data.getbyte(20)
  number_of_patterns = mod_data.getbyte(21)
  number_of_samples = mod_data.getbyte(22)

  # Affichage des informations de l'en-tête
  puts "Nom du module : #{module_name}"
  puts "Nombre de canaux : #{number_of_channels}"
  puts "Nombre de patterns : #{number_of_patterns}"
  puts "Nombre d'échantillons : #{number_of_samples}"
end

def read_mod_pattern_order_table(file_path)
  mod_data = File.binread(file_path)

  pattern_order_table = mod_data[952..1083]
  pattern_order = pattern_order_table.bytes.to_a

  puts "Pattern Order Table:"
  pattern_order.each_with_index do |pattern_index, order_index|
    puts "Order #{order_index + 1}: Pattern #{pattern_index}"
  end
end

def read_mod_sample_data(file_path)
  mod_data = File.binread(file_path)

  sample_data_offset = 20 + (mod_data[950] * 4)
  sample_data = mod_data[sample_data_offset..-1]

  puts "Sample Data for #{File.basename(file_path)}:"
  sample_data.each_byte.each_slice(2) do |sample_byte_1, sample_byte_2|
    sample_value = (sample_byte_1.ord << 8) + sample_byte_2.ord
    puts sample_value
  end
end

def read_mod_sample_data(file_path)
  mod_data = File.binread(file_path)

  sample_data_offset = 20
  sample_data_size = 30 * 1024

  # Parcours des données d'échantillon
  (0..29).each do |sample_index|
    sample_offset = sample_data_offset + sample_index * 30

    sample_name = mod_data[sample_offset, 22].unpack("A22").first.strip
    sample_length = mod_data[sample_offset + 22, 2].unpack("n").first * 2
    sample_finetune = mod_data[sample_offset + 24].unpack("c").first
    sample_volume = mod_data[sample_offset + 25].unpack("c").first
    sample_repeat = mod_data[sample_offset + 26, 2].unpack("n").first * 2
    sample_replen = mod_data[sample_offset + 28, 2].unpack("n").first * 2

    puts "Échantillon #{sample_index + 1}:"
    puts "Nom : #{sample_name}"
    puts "Longueur : #{sample_length}"
    puts "Finetune : #{sample_finetune}"
    puts "Volume : #{sample_volume}"
    puts "Position de répétition : #{sample_repeat}"
    puts "Taille de répétition : #{sample_replen}"

    # Affichage des données binaires brutes de l'échantillon
    sample_data = mod_data[sample_data_offset + sample_length, sample_data_size]
    #puts "Données binaires : #{sample_data.unpack("H*").first}"
  end
end

def read_mod_sample_names(file_path)
  mod_data = File.binread(file_path)

  sample_names_offset = 20
  sample_names_size = 22 * 31

  sample_names_data = mod_data[sample_names_offset, sample_names_size]

  # Parcours des noms d'échantillons
  (0..30).each do |sample_index|
    sample_name = sample_names_data[sample_index * 22, 22].unpack("A22").first.strip

    puts "Échantillon #{sample_index + 1}: #{sample_name}"
  end
end

def read_mod_sample_names(file_path)
  mod_data = File.binread(file_path, encoding: 'ASCII-8BIT')

  sample_names_offset = 20
  sample_names_size = 22 * 31

  sample_names_data = mod_data[sample_names_offset, sample_names_size]

  # Parcours des noms d'échantillons
  (0..30).each do |sample_index|
    sample_name = sample_names_data[sample_index * 22, 22].force_encoding('ASCII-8BIT').unpack("A22").first.strip.force_encoding('UTF-8')

    puts "Échantillon #{sample_index + 1}: #{sample_name}"
  end
end

def read_mod_sample_names(file_path)
  mod_data = File.binread(file_path, encoding: 'ASCII-8BIT')

  sample_names_offset = 20
  sample_names_size = 22 * 31

  sample_names_data = mod_data[sample_names_offset, sample_names_size]

  # Parcours des noms d'échantillons
  (0..30).each do |sample_index|
    sample_name = sample_names_data[sample_index * 22, 22].force_encoding('ASCII-8BIT').unpack("A22").first.strip.force_encoding('UTF-8')

    puts "Échantillon #{sample_index + 1}: #{sample_name}"
  end
end

def read_mod_sample_names(file_path)
    #mod_data = File.binread(file_path, encoding: 'ASCII-8BIT')
    mod_data = File.binread(file_path)

    sample_names_offset = 20
    sample_names_size = 22 * 31

    sample_names_data = mod_data[sample_names_offset, sample_names_size]

    # Parcours des noms d'échantillons
    (0..30).each do |sample_index|
      sample_name = sample_names_data[sample_index * 22, 22]
        .unpack("A22")
        .first
        .strip
        .force_encoding('UTF-8')

      puts "Échantillon #{sample_index + 1}: #{sample_name}"
    end
end

def read_mod_comment(file_path)
  mod_data = File.binread(file_path)

  comment_offset = 1080
  comment_data = mod_data[comment_offset, 1084 - comment_offset]

  # Supprimer les caractères de remplissage nuls
  comment_data.gsub!("\x00", "")

  puts "Commentaire :#{comment_data.size}:"
  puts comment_data
end

# Utilisation : spécifiez le chemin vers votre fichier MOD
#read_mod_file("falso_siddo.mod")
#read_mod_pattern_order_table("falso_siddo.mod")

# Utilisation : spécifiez le chemin vers votre fichier MOD en tant qu'argument du script
if ARGV.empty?
  puts "Veuillez spécifier le chemin vers votre fichier MOD en tant qu'argument du script."
else
  file_path = ARGV[0]
  #read_mod_pattern_order_table(file_path)
  #read_mod_file_header(file_path)
  #read_mod_sample_names(file_path)
  read_mod_comment(file_path)
end
