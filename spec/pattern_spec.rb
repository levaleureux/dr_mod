# Specs de Pattern : décodage d'un pattern ProTracker (64 lignes de 4 cellules).
#
# Un pattern occupe 1024 octets (64 lignes × 4 cellules × 4 octets) dans le
# fichier MOD. D'après PROTRACKER_1_1_B[:pattern_data] :
#   offset = 1084, bytes (taille d'un pattern) = 1024
# Pattern calcule donc son offset de départ ainsi (cf. pattern.rb#init_attrs) :
#   @pattern_offset = 1084 + 1024 * num
# Puis, pour chaque ligne r (0..63), il lit 16 octets à
#   @pattern_offset + r * 16
# qu'il découpe en 4 tranches de 4 octets, chacune confiée à Cell.new.
#
# Comme `decode_pattern_line` fait `@mod_data[offset, 16].unpack("C*")`,
# `mod_data` doit être une CHAÎNE binaire d'octets : on la fabrique avec
# `Array#pack("C*")`.
#
# Format d'une cellule (4 octets), tel que décodé par Cell / CellBin :
#   sample_number   = (octet0 & 0xF0) | ((octet2 & 0xF0) >> 4)
#   note_period     = ((octet0 & 0x0F) << 8) | octet1     (12 bits)
#   effect_command  = (octet3 & 0xF0) >> 4
#   effect_argument =  octet3 & 0x0F
#
# Mise en place via `let` : `mod_data` est surchargé dans les contextes,
# `num` vaut 0 par défaut, et `pattern` se reconstruit automatiquement.

spec "Pattern" do
  # Helper de fabrication d'une chaîne MOD minimale.
  #
  # On place `cells` (un tableau plat d'octets, multiple de 16 souhaitable)
  # à l'offset d'un pattern donné, le reste rempli de zéros. La chaîne est
  # dimensionnée pour couvrir le pattern entier (1024 octets) à partir de
  # son offset, afin que les 64 lignes soient toujours lisibles.
  let(:base_offset) { 1084 }          # PROTRACKER_1_1_B[:pattern_data][:offset]
  let(:pattern_size) { 1024 }         # PROTRACKER_1_1_B[:pattern_data][:bytes]
  let(:num) { 0 }
  let(:pattern_offset) { base_offset + pattern_size * num }

  # Octets significatifs à injecter à partir de `pattern_offset` (par défaut
  # aucun : tout le pattern est silencieux).
  let(:payload) { [] }

  # Chaîne binaire : zéros jusqu'à pattern_offset, puis le payload, puis des
  # zéros de remplissage pour garantir au moins 1024 octets de pattern.
  let(:mod_data) do
    bytes = Array.new(pattern_offset, 0)
    bytes.concat(payload)
    # Complète jusqu'à couvrir tout le pattern (offset + 1024 octets).
    needed = pattern_offset + pattern_size
    bytes.concat(Array.new(needed - bytes.length, 0)) if bytes.length < needed
    bytes.pack("C*")
  end

  let(:pattern) { Pattern.new(mod_data, num) }

  context "structure d'un pattern entièrement silencieux" do
    specify "expose 64 lignes" do
      expect(pattern.rows.length).to eq 64
    end

    specify "chaque ligne comporte exactement 4 cellules" do
      counts = pattern.rows.map { |row| row.length }
      expect(counts.uniq).to eq [4]
    end

    specify "chaque cellule est une instance de Cell" do
      classes = pattern.rows.flatten.map { |cell| cell.class }
      expect(classes.uniq).to eq [Cell]
    end

    specify "le numéro du pattern est conservé" do
      expect(pattern.num).to eq 0
    end

    context "sur un pattern silencieux, toute cellule décode des zéros" do
      specify "le numéro d'échantillon de la première cellule est 0" do
        expect(pattern.rows[0][0].sample_number).to eq 0
      end

      specify "la période de la première cellule est 0" do
        expect(pattern.rows[0][0].note_period).to eq 0
      end

      specify "la commande d'effet de la dernière cellule est 0" do
        expect(pattern.rows[63][3].effect_command).to eq 0
      end
    end
  end

  context "décodage d'une cellule connue en première ligne, première colonne" do
    # On veut une cellule de 4 octets aux valeurs maîtrisées :
    #   octet0 = 0x10, octet1 = 0xD6, octet2 = 0x20, octet3 = 0x23
    #
    # Attendus (cf. format ci-dessus) :
    #   sample_number   = (0x10 & 0xF0) | ((0x20 & 0xF0) >> 4)
    #                   = 0x10 | (0x20 >> 4) = 0x10 | 0x02 = 0x12 = 18
    #   note_period     = ((0x10 & 0x0F) << 8) | 0xD6 = (0x0 << 8) | 0xD6 = 0xD6 = 214
    #   effect_command  = (0x23 & 0xF0) >> 4 = 0x2 = 2
    #   effect_argument =  0x23 & 0x0F = 0x3 = 3
    #
    # Cette cellule occupe les 4 premiers octets du pattern (ligne 0, colonne 0).
    let(:payload) { [0x10, 0xD6, 0x20, 0x23] }
    let(:cell) { pattern.rows[0][0] }

    specify "le numéro d'échantillon vaut 18" do
      expect(cell.sample_number).to eq 18
    end

    specify "la période vaut 214 (note C-3)" do
      expect(cell.note_period).to eq 214
    end

    specify "la commande d'effet vaut 2" do
      expect(cell.effect_command).to eq 2
    end

    specify "l'argument d'effet vaut 3" do
      expect(cell.effect_argument).to eq 3
    end

    specify "la deuxième cellule de la première ligne reste silencieuse" do
      # Les octets 4..7 du pattern sont nuls : cellule [0][1] toute à zéro.
      expect(pattern.rows[0][1].note_period).to eq 0
    end
  end

  context "découpage des quatre cellules d'une même ligne" do
    # Une ligne entière (16 octets) avec une période distincte par colonne,
    # afin de vérifier que chaque tranche de 4 octets alimente la bonne cellule.
    #
    # Colonne 0 : octets [0x00, 0x6A, ...] -> période 0x06A = 106
    # Colonne 1 : octets [0x01, 0x90, ...] -> période 0x190 = 400
    # Colonne 2 : octets [0x02, 0x00, ...] -> période 0x200 = 512
    # Colonne 3 : octets [0x03, 0x58, ...] -> période 0x358 = 856 (note C-1)
    #
    # Rappel : note_period = ((octet0 & 0x0F) << 8) | octet1.
    let(:payload) do
      [
        0x00, 0x6A, 0x00, 0x00,  # colonne 0
        0x01, 0x90, 0x00, 0x00,  # colonne 1
        0x02, 0x00, 0x00, 0x00,  # colonne 2
        0x03, 0x58, 0x00, 0x00   # colonne 3
      ]
    end

    specify "les périodes des quatre colonnes sont décodées dans l'ordre" do
      periods = pattern.rows[0].map { |cell| cell.note_period }
      expect(periods).to eq [106, 400, 512, 856]
    end
  end

  context "ciblage d'une ligne au-delà de la première" do
    # On vise la ligne 2 (line_offset = 2), dont les 16 octets commencent à
    # l'offset relatif 2 * 16 = 32 dans le pattern. On préfixe donc le payload
    # de 32 octets nuls (lignes 0 et 1 silencieuses), puis une cellule connue.
    #
    # Cellule visée (ligne 2, colonne 0) :
    #   octet0 = 0xA0, octet1 = 0x00, octet2 = 0x50, octet3 = 0xC4
    #   sample_number   = (0xA0 & 0xF0) | ((0x50 & 0xF0) >> 4)
    #                   = 0xA0 | (0x50 >> 4) = 0xA0 | 0x05 = 0xA5 = 165
    #   effect_command  = (0xC4 & 0xF0) >> 4 = 0xC = 12
    #   effect_argument =  0xC4 & 0x0F = 0x4 = 4
    let(:payload) do
      Array.new(32, 0) + [0xA0, 0x00, 0x50, 0xC4]
    end
    let(:cell) { pattern.rows[2][0] }

    specify "le numéro d'échantillon de la ligne 2 vaut 165" do
      expect(cell.sample_number).to eq 165
    end

    specify "la commande d'effet de la ligne 2 vaut 12" do
      expect(cell.effect_command).to eq 12
    end

    specify "l'argument d'effet de la ligne 2 vaut 4" do
      expect(cell.effect_argument).to eq 4
    end

    specify "la ligne 0 demeure silencieuse" do
      expect(pattern.rows[0][0].sample_number).to eq 0
    end
  end

  context "sélection d'un pattern d'indice non nul" do
    # Avec num = 1, l'offset de départ devient 1084 + 1024 = 2108.
    # `pattern_offset` (let dérivé) suit automatiquement, et le payload est
    # placé au bon endroit par le helper `mod_data`.
    #
    # Cellule visée (pattern 1, ligne 0, colonne 0) :
    #   octet0 = 0x00, octet1 = 0xAC, ... -> période 0x0AC = 172
    let(:num) { 1 }
    let(:payload) { [0x00, 0xAC, 0x00, 0x00] }

    specify "l'indice du pattern est 1" do
      expect(pattern.num).to eq 1
    end

    specify "il expose également 64 lignes" do
      expect(pattern.rows.length).to eq 64
    end

    specify "la cellule de tête décode la période 172 propre au pattern 1" do
      expect(pattern.rows[0][0].note_period).to eq 172
    end
  end
end
