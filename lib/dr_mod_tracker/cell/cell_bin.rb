#
# A pattern has line and a line has cell
#
# see https://youtu.be/0_6eBiouooo?t=1046
# for a visual explenation
#
#note        = (note_byte & 0x0F)
#sample      = ((note_byte & 0xF0) >> 4)
#instrument  = (instrument_byte & 0xF0) | ((effect_byte & 0xF0) >> 4)
#effect      = (effect_byte & 0x0F)
#effect_data = effect_data_byte

#
#
module CellBin

  # keep only the 4 left bits
  # by masking with 0xF0 = 11110000
  def high_bits byte
    byte & 0xF0
  end

  # keep only the 4 right bits
  # by masking with 0xF0 = 00001111
  def low_bits byte
    byte & 0x0F
  end
  # 8-Bits for the sample number
  # 4 bits in Byte 1, the 4 first bits
  # 4 bits in Byte 3, the 4 first bits
  #
  def read_sample_number cell_bytes
    high_weights = high_bits(cell_bytes[0])
    low_weights  = high_bits(cell_bytes[2])
    # move low_bits by 4 column and merge with | operator
    # to create one Byte
    sample_number = high_weights | (low_weights >> 4)
    # puts "sample_number #{cell_bytes} #{sample_number}"
    sample_number
  end

  # @note_period : Cet attribut représente la période de la note jouée.
  # Les 12 bits les moins significatifs sont répartis entre le premier et le deuxième octet.
  # On prend les 4 bits les moins significatifs du premier octet (cell_data[0] & 0x0F)
  # qu'on déplace de 8 bits à gauche, puis on ajoute le deuxième octet entier (cell_data[1]).
  def bytes_to_note_periode(cell_data)
    ((cell_data[1] & 0x0F) << 8) | cell_data[2]
  end

  def print_note_period note_period
    bytes = note_period_to_bytes(note_period)
    str = format "note periored -%d- 0x%X 0x%X", note_period, bytes[0], bytes[1]
    puts str
    str
  end

  # Méthode de classe pour convertir une période de note
  # en 12 bits
  # soit 2 octet
  def note_period_to_bytes(note_period)
    # Bits 11-8
    note_shifted = (note_period >> 8)
    low_byte     = note_period & 0xFF
    #
    [note_shifted, low_byte]
  end

  # Méthode de classe pour créer un tableau de 4 bytes à partir de la période de note
  def construct_cell_data_for_note_periode(note_period)
    bytes = note_periode_to_bytes(note_period)
    [bytes[0], bytes[1], bytes[2], 0x00]  # 4 bytes, le dernier étant initialisé à zéro
  end

end
