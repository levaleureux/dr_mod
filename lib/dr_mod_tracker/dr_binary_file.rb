#
# Use to
# Read a bin amiga file
#
class BinaryFile
  def initialize file_path
    @file_path = file_path
    #@file_data = File.binread(@file_path)
    @file_data = $gtk.read_file file_path
  end

  def read_word offset = 0
    word_data = @file_data[offset, 2]
    word_data.unpack('S<').first
  end

  def read_octet offset = 0
    octet_data = @file_data[offset, 1]
    octet_data.unpack('C').first
  end
end

# Exemple d'utilisation
#file = BinaryFile.new('data.bin')

# Lire un octet à partir de l'offset 10
#octet_at_offset_10 = file.read_octet(10)
#puts "Octet read from offset 10: #{octet_at_offset_10}"
