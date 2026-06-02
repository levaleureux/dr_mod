# Specs de Song : décodage de l'en-tête d'un module ProTracker 1.1B.
#
# `Song.new(mod_data)` reçoit les octets bruts du fichier (.mod) sous forme
# de chaîne binaire : `SongSetup` et `LoadTool` y appliquent `String#unpack`
# et le découpage `chaine[offset, taille]`. Les fixtures ci-dessous ne lisent
# donc aucun fichier ; elles fabriquent un en-tête synthétique à la position
# exacte de chaque champ, d'après la table `PROTRACKER_1_1_B`.
#
# Carte de l'en-tête utilisée (offsets en octets) :
#   0    : song_name        (20 octets, chaîne brute)
#   950  : song_length      (1 octet)
#   951  : tracker_byte     (1 octet)
#   952  : song_positions   (128 octets, indices de patterns 0-63)
#   1080 : format_signature (4 octets, p. ex. « M.K. »)
#
# Mise en place via `let` : les champs élémentaires (`song_name`,
# `song_length`, `positions`, `signature`) sont surchargés dans les contextes
# imbriqués, et `header_bytes` recompose le tampon d'octets à partir d'eux ;
# `mod_data` en dérive la chaîne binaire et `song` l'objet sous test.
#
# Le module d'affichage `SongPrint` (puts_info, puts_song_positions) relève de
# la présentation et n'est pas couvert ici.

spec "Song" do
  # Taille minimale d'en-tête : juste de quoi loger la signature (1080..1083).
  let(:header_size) { 1084 }

  # Nom du morceau : 20 octets bruts à l'offset 0.
  let(:song_name) { "xenon3miniblast" }

  # Longueur du morceau (nombre de positions jouées) : 1 octet à l'offset 950.
  let(:song_length) { 29 }

  # Octet « tracker » historique (offset 951), classiquement 127.
  let(:tracker_byte) { 127 }

  # Table des positions (offset 952) : indices de patterns. Le pattern le plus
  # haut de cette fixture est 17, ce qui doit donner pattern_count = 18.
  let(:positions) { [0, 1, 2, 1, 17, 5, 0] }

  # Signature de format (offset 1080) : « M.K. » pour 31 échantillons.
  let(:signature) { "M.K." }

  # Recompose le tampon d'octets de l'en-tête à partir des champs ci-dessus.
  let(:header_bytes) do
    bytes = Array.new(header_size, 0)
    write_string(bytes, 0, song_name)
    bytes[950] = song_length & 0xFF
    bytes[951] = tracker_byte & 0xFF
    positions.each_with_index { |value, index| bytes[952 + index] = value & 0xFF }
    write_string(bytes, 1080, signature)
    bytes
  end

  # Chaîne binaire transmise à Song, telle que la fournirait DrMod.
  let(:mod_data) { header_bytes.pack("C*") }

  let(:song) { Song.new(mod_data) }

  # Écrit les octets d'une chaîne ASCII dans le tampon à partir d'un offset.
  def write_string(bytes, offset, text)
    text.each_byte.with_index { |octet, index| bytes[offset + index] = octet }
  end

  context "décodage du nom de morceau" do
    specify "expose le nom brut décodé depuis l'offset 0" do
      expect(song.name.strip).to eq "xenon3miniblast"
    end

    context "lorsque le nom diffère" do
      let(:song_name) { "demo song" }
      specify "reflète le nouveau nom" do
        expect(song.name.strip).to eq "demo song"
      end
    end
  end

  context "décodage de la longueur" do
    specify "vaut 29 positions" do
      expect(song.length).to eq 29
    end

    context "longueur unitaire" do
      let(:song_length) { 1 }
      specify "vaut 1" do
        expect(song.length).to eq 1
      end
    end

    context "longueur maximale (128 positions)" do
      let(:song_length) { 128 }
      specify "vaut 128" do
        expect(song.length).to eq 128
      end
    end
  end

  context "décodage de l'octet tracker" do
    specify "vaut 127, la valeur historique" do
      expect(song.tracker_byte).to eq 127
    end
  end

  context "décodage de la signature de format" do
    specify "reconnaît « M.K. » (31 échantillons)" do
      expect(song.format_signature).to eq "M.K."
    end

    context "variante Star Trekker à quatre voies" do
      let(:signature) { "FLT4" }
      specify "expose « FLT4 »" do
        expect(song.format_signature).to eq "FLT4"
      end
    end
  end

  context "décodage de la table des positions" do
    specify "expose les 128 octets décodés en tableau d'entiers" do
      expect(song.song_positions.length).to eq 128
    end

    specify "préserve les indices effectivement écrits" do
      expect(song.song_positions.take(7)).to eq [0, 1, 2, 1, 17, 5, 0]
    end

    specify "complète par des zéros au-delà des positions écrites" do
      expect(song.song_positions[7]).to eq 0
    end
  end

  context "pattern_count : plus haut indice de position + 1" do
    specify "vaut 18 quand l'indice maximal est 17" do
      expect(song.pattern_count).to eq 18
    end

    context "table de positions réduite" do
      let(:positions) { [0, 0, 0] }
      specify "vaut 1 quand tous les indices valent 0" do
        expect(song.pattern_count).to eq 1
      end
    end

    context "indice maximal isolé en fin de liste" do
      let(:positions) { [0, 1, 2, 63] }
      specify "vaut 64 quand l'indice maximal est 63" do
        expect(song.pattern_count).to eq 64
      end
    end
  end

  context "constantes de disposition" do
    specify "samples_count vaut 31 (ProTracker 1.1B)" do
      expect(song.samples_count).to eq 31
    end

    specify "pattern_size vaut 1024 octets (64 lignes × 16)" do
      expect(song.pattern_size).to eq 1024
    end
  end

  context "samples_start_at : fin de l'en-tête et des patterns" do
    # 1084 (en-tête) + pattern_count × 1024.
    specify "vaut 1084 + 18 × 1024 pour cette table" do
      expect(song.samples_start_at).to eq(1084 + (18 * 1024))
    end

    context "lorsque le nombre de patterns change" do
      let(:positions) { [0, 0, 0] }
      specify "suit pattern_count (un seul pattern)" do
        expect(song.samples_start_at).to eq(1084 + (1 * 1024))
      end
    end
  end
end
