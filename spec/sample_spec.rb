# Specs de Sample : décodage d'un en-tête d'échantillon ProTracker.
#
# Chaque échantillon possède un en-tête de 30 octets, situé à l'offset
# `num * 30` dans le module. À l'intérieur de cet en-tête, les attributs se
# répartissent ainsi (offsets relatifs, format PROTRACKER_1_1_B) :
#
#   offset 20, 22 octets : nom (chaîne, complétée par des octets nuls)
#   offset 42,  2 octets : longueur, en MOTS Amiga big-endian
#                          (length = mot * 2, soit la taille en octets)
#   offset 44,  1 octet  : finetune, quartet bas signé sur 4 bits (-8 à +7)
#   offset 45,  1 octet  : volume, plage 0 à 64
#   offset 46,  2 octets : point de boucle, en mots Amiga big-endian
#   offset 48,  2 octets : longueur de boucle, en mots Amiga big-endian
#
# Mise en place via `let` : `mod_data` fournit les octets bruts du module
# (chaîne binaire obtenue par `pack("C*")`), `num` désigne l'échantillon
# visé, et `sample` se reconstruit automatiquement à partir des deux. Les
# contextes imbriqués surchargent `mod_data` (et parfois `num`) pour isoler
# chaque attribut sans réécrire la mécanique de construction.
#
# Les méthodes d'affichage du module SamplePrint (puts_info, puts_info_data)
# relèvent du rendu et sont délibérément laissées hors de cette couverture.

spec "Sample" do
  # Un module vierge : 1200 octets nuls, suffisant pour décoder l'en-tête de
  # l'échantillon 0. `with_bytes` recopie ce gabarit puis y insère, à un
  # offset donné, une suite d'octets : c'est l'outil de surcharge des `let`.
  let(:base_bytes) { [0] * 1200 }
  let(:num)        { 0 }
  let(:mod_data)   { base_bytes.pack("C*") }
  let(:sample)     { Sample.new(num, mod_data) }

  # Construit une chaîne binaire à partir du gabarit vierge en y plaçant
  # `values` à partir de `offset`. Sert aux contextes ciblant un attribut.
  def with_bytes(offset, values)
    bytes = ([0] * 1200)
    values.each_with_index { |byte, index| bytes[offset + index] = byte }
    bytes.pack("C*")
  end

  context "construction et indexation" do
    specify "mémorise le numéro d'échantillon reçu" do
      expect(sample.num).to eq 0
    end

    specify "calcule l'offset de l'en-tête à num * 30" do
      expect(sample.s_offset).to eq 0
    end

    context "échantillon d'indice 3" do
      let(:num) { 3 }

      specify "place l'offset de l'en-tête à 90" do
        expect(sample.s_offset).to eq 90
      end
    end
  end

  context "longueur (offset 42, mot Amiga, exprimée en octets)" do
    context "échantillon vide" do
      specify "vaut 0 lorsque le mot de longueur est nul" do
        expect(sample.length).to eq 0
      end
    end

    context "mot de longueur 0x0001" do
      let(:mod_data) { with_bytes(42, [0x00, 0x01]) }

      specify "vaut 2 octets (un mot multiplié par deux)" do
        expect(sample.length).to eq 2
      end
    end

    context "mot de longueur 0x0100 = 256" do
      let(:mod_data) { with_bytes(42, [0x01, 0x00]) }

      specify "vaut 512 octets" do
        expect(sample.length).to eq 512
      end
    end

    context "échantillon d'indice 1, mot de longueur 0x000A" do
      let(:num) { 1 }
      # En-tête de l'échantillon 1 à l'offset 30 ; longueur à 30 + 42 = 72.
      let(:mod_data) { with_bytes(72, [0x00, 0x0A]) }

      specify "décode la longueur depuis le bon en-tête (20 octets)" do
        expect(sample.length).to eq 20
      end
    end
  end

  context "finetune (offset 44, quartet bas signé sur 4 bits)" do
    context "valeur neutre" do
      specify "vaut 0 lorsque l'octet est nul" do
        expect(sample.finetune).to eq 0
      end
    end

    context "quartet bas 0x07 (maximum positif)" do
      let(:mod_data) { with_bytes(44, [0x07]) }

      specify "vaut +7" do
        expect(sample.finetune).to eq 7
      end
    end

    context "quartet bas 0x08 (premier pas négatif)" do
      let(:mod_data) { with_bytes(44, [0x08]) }

      specify "vaut -8" do
        expect(sample.finetune).to eq(-8)
      end
    end

    context "quartet bas 0x0F (dernier pas négatif)" do
      let(:mod_data) { with_bytes(44, [0x0F]) }

      specify "vaut -1" do
        expect(sample.finetune).to eq(-1)
      end
    end

    context "quartet haut renseigné (0xF7) mais ignoré" do
      let(:mod_data) { with_bytes(44, [0xF7]) }

      specify "ne retient que le quartet bas, soit +7" do
        expect(sample.finetune).to eq 7
      end
    end
  end

  context "volume (offset 45, plage 0 à 64)" do
    context "valeur par défaut" do
      specify "vaut 0 lorsque l'octet est nul" do
        expect(sample.volume).to eq 0
      end
    end

    context "octet de volume 0x40 = 64 (maximum)" do
      let(:mod_data) { with_bytes(45, [0x40]) }

      specify "vaut 64" do
        expect(sample.volume).to eq 64
      end
    end

    context "octet de volume 0x20 = 32 (intermédiaire)" do
      let(:mod_data) { with_bytes(45, [0x20]) }

      specify "vaut 32" do
        expect(sample.volume).to eq 32
      end
    end
  end

  context "point de boucle (offset 46, mot Amiga)" do
    context "absence de boucle" do
      specify "vaut 0 lorsque le mot est nul" do
        expect(sample.repeat_point).to eq 0
      end
    end

    context "mot 0x0002" do
      let(:mod_data) { with_bytes(46, [0x00, 0x02]) }

      specify "vaut 2" do
        expect(sample.repeat_point).to eq 2
      end
    end

    context "mot 0x0100 = 256" do
      let(:mod_data) { with_bytes(46, [0x01, 0x00]) }

      specify "vaut 256" do
        expect(sample.repeat_point).to eq 256
      end
    end
  end

  context "longueur de boucle (offset 48, mot Amiga)" do
    context "boucle minimale" do
      specify "vaut 0 lorsque le mot est nul" do
        expect(sample.repeat_length).to eq 0
      end
    end

    context "mot 0x0001" do
      let(:mod_data) { with_bytes(48, [0x00, 0x01]) }

      specify "vaut 1" do
        expect(sample.repeat_length).to eq 1
      end
    end

    context "mot 0x00FF = 255" do
      let(:mod_data) { with_bytes(48, [0x00, 0xFF]) }

      specify "vaut 255" do
        expect(sample.repeat_length).to eq 255
      end
    end
  end

  context "nom (offset 20, 22 octets, complété par des octets nuls)" do
    context "nom absent" do
      specify "renvoie 22 octets nuls" do
        expect(sample.name).to eq(([0] * 22).pack("C*"))
      end
    end

    context "nom « SNARE » suivi d'octets nuls" do
      # Codes ASCII de S, N, A, R, E placés à l'offset 20.
      let(:mod_data) { with_bytes(20, [83, 78, 65, 82, 69]) }

      specify "restitue les 22 octets bruts, padding compris" do
        expected = ([83, 78, 65, 82, 69] + [0] * 17).pack("C*")
        expect(sample.name).to eq expected
      end
    end
  end

  context "normalize_value : conversion d'un octet en flottant signé" do
    # La normalisation ne dépend pas de l'en-tête ; un échantillon vierge
    # suffit à exercer la transformation arithmétique.
    specify "associe 0 au silence positif 0.0" do
      expect(sample.normalize_value(0)).to eq 0.0
    end

    specify "place 127 juste sous 1.0 (positif maximal)" do
      expect(sample.normalize_value(127)).to be_greater_than 0.99
    end

    specify "associe 128 à -1.0 (négatif maximal)" do
      expect(sample.normalize_value(128)).to eq(-1.0)
    end

    specify "place 255 juste sous 0.0 (négatif proche de zéro)" do
      expect(sample.normalize_value(255)).to be_greater_than(-0.01)
    end

    specify "maintient toute valeur normalisée dans [-1.0, 1.0]" do
      expect(sample.normalize_value(64)).to be_between(-1.0, 1.0)
    end
  end
end
