# Specs de Cell : décodage d'une cellule ProTracker (4 octets).
#
# Format d'une cellule (4 octets) :
#   octet 0 : quartet haut = bits hauts du n° d'échantillon,
#             quartet bas  = bits hauts de la période (12 bits)
#   octet 1 : octet bas de la période
#   octet 2 : quartet haut = bits bas du n° d'échantillon,
#             quartet bas  = commande d'effet
#   octet 3 : argument d'effet
#
# Mise en place via `let` : `data` (les 4 octets) est surchargé dans chaque
# contexte, `cell` se reconstruit automatiquement à partir de `data`.

spec "Cell" do
  let(:data) { [0x00, 0x00, 0x00, 0x00] }
  let(:cell) { Cell.new(data) }

  context "silence (tous les octets à zéro)" do
    specify "le numéro d'échantillon est 0" do
      expect(cell.sample_number).to eq 0
    end

    specify "le numéro d'échantillon est un entier" do
      expect(cell.sample_number).to be_a(Integer)
    end

    specify "la période est 0" do
      expect(cell.note_period).to eq 0
    end

    specify "la commande d'effet est 0" do
      expect(cell.effect_command).to eq 0
    end

    specify "l'argument d'effet est 0" do
      expect(cell.effect_argument).to eq 0
    end
  end

  context "numéro d'échantillon (octet 0 haut + octet 2 haut)" do
    context "cas de base 0x12 = 18" do
      let(:data) { [0x10, 0x00, 0x20, 0x00] }
      specify "vaut 18" do
        expect(cell.sample_number).to eq 18
      end
    end

    context "maximum 0xFF = 255" do
      let(:data) { [0xF0, 0x00, 0xF0, 0x00] }
      specify "vaut 255" do
        expect(cell.sample_number).to eq 255
      end
    end

    context "bits mêlés 0xA5 = 165" do
      let(:data) { [0xA0, 0x00, 0x50, 0x00] }
      specify "vaut 165" do
        expect(cell.sample_number).to eq 165
      end
    end
  end

  context "période (12 bits, octet 0 bas + octet 1)" do
    context "C-3 = 214 (0x0D6)" do
      let(:data) { [0x00, 0xD6, 0x00, 0x00] }
      specify "vaut 214" do
        expect(cell.note_period).to eq 214
      end
    end

    context "C-1 = 856 (0x358)" do
      let(:data) { [0x03, 0x58, 0x00, 0x00] }
      specify "vaut 856" do
        expect(cell.note_period).to eq 856
      end
    end
  end

  context "effet (octet 3 : commande haute, argument bas)" do
    context "0x23 -> commande 2, argument 3" do
      let(:data) { [0x00, 0x00, 0x00, 0x23] }
      specify "la commande vaut 2" do
        expect(cell.effect_command).to eq 2
      end
      specify "l'argument vaut 3" do
        expect(cell.effect_argument).to eq 3
      end
    end

    context "volume slide 0xA5 -> commande 0xA, argument 5" do
      let(:data) { [0x00, 0x00, 0x00, 0xA5] }
      specify "la commande vaut 0xA" do
        expect(cell.effect_command).to eq 0xA
      end
      specify "l'argument vaut 5" do
        expect(cell.effect_argument).to eq 5
      end
    end
  end

  context "informations formatées (CellInfo)" do
    context "cellule silencieuse" do
      specify "info_verbose détaille les quatre champs à zéro" do
        expect(cell.info_verbose).to eq [
          "Sample Number: 0,  ",
          "Note Period: 0, ",
          "Effect Command: 0, ",
          "Effect Argument: 0"
        ]
      end

      specify "info affiche un échantillon 00, une note vide et des effets vides" do
        # période 0 -> note "   " ; effets 0 -> "   " ; séparateur U+2503
        expect(cell.info).to eq ["00", "   ", "   ", "   "].join("┃")
      end
    end

    context "cellule avec échantillon et effet" do
      let(:data) { [0x10, 0x00, 0x20, 0x23] } # échantillon 18, effet 2 arg 3
      specify "info formate le numéro d'échantillon et les effets non nuls" do
        # 18 -> "18" ; commande 2 -> "002" ; argument 3 -> "003"
        champs = cell.info.split("┃")
        expect(champs.first).to eq "18"
        expect(champs.last).to eq "003"
      end
    end

    context "cellule avec une période de note connue" do
      let(:data) { [0x00, 0xD6, 0x00, 0x00] } # période 214 (C-3)
      specify "info renvoie une chaîne structurée par le séparateur" do
        # exerce la branche de recherche de note (note_period != 0)
        expect(cell.info.split("┃").length).to eq 4
      end
    end
  end
end
