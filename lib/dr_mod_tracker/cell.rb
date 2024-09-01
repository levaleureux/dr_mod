#
# A pattern has line and a line has cell
#
#note        = (note_byte & 0x0F)
#sample      = ((note_byte & 0xF0) >> 4)
#instrument  = (instrument_byte & 0xF0) | ((effect_byte & 0xF0) >> 4)
#effect      = (effect_byte & 0x0F)
#effect_data = effect_data_byte
# La classe Cell représente une cellule individuelle d'une ligne d'un pattern dans un fichier MOD.
class Cell

  include LoadTool
  include CellBin
  attr_reader :sample_number, :note_period, :effect_command, :effect_argument

  # L'initialisation de l'objet Cell prend un tableau de 4 octets (cell_data)
  # représentant une cellule d'une ligne d'un pattern dans un fichier MOD.
  def initialize(cell_data)
    # NOTE: see CellBin and doc .md
    # TODO: add some validation: size array, type
    @sample_number = read_sample_number cell_data

    # @note_period : Cet attribut représente la période de la note jouée.
    # Les 12 bits les moins significatifs sont répartis entre le premier et le deuxième octet.
    # On prend les 4 bits les moins significatifs du premier octet (cell_data[0] & 0x0F)
    # qu'on déplace de 8 bits à gauche, puis on ajoute le deuxième octet entier (cell_data[1]).
    @note_period = ((cell_data[0] & 0x0F) << 8) | cell_data[1]

    # @effect_command : Cet attribut représente la commande d'effet à appliquer à cette note.
    # La commande d'effet est stockée dans les 4 bits les plus significatifs du quatrième octet (cell_data[3] & 0xF0),
    # et elle est décalée de 4 bits à droite pour être représentée sur 4 bits.
    @effect_command = (cell_data[3] & 0xF0) >> 4

    # @effect_argument : Cet attribut représente les paramètres (arguments) de la commande d'effet.
    # L'argument est stocké dans les 4 bits les moins significatifs du quatrième octet (cell_data[3] & 0x0F).
    @effect_argument = cell_data[3] & 0x0F
  end
end

def info_verbose
  [ "Sample Number: #{@sample_number},  ",
    "Note Period: #{@note_period}, ",
    "Effect Command: #{@effect_command}, ",
    "Effect Argument: #{@effect_argument}"
  ]
end

def info
  note = @note_period == 0 ? "   " :  T_SPEC[:notes][@note_period]
  note = note == "" ? "blk" : note
  data(note).join("\u2503")
end

def info_effect val
  val == 0 ? "   " : format('%03d', val)
end

private

def data note
  [ format('%02d', @sample_number),
    note,
    info_effect(@effect_command),
    info_effect(@effect_argument)
  ]
end
