# dr_mod - Lecteur de fichiers Amiga MOD pour DragonRuby

## Description

dr_mod est un loader/player de fichiers audio Amiga MOD (format ProTracker 1.1B) pour DragonRuby Game Toolkit. Il parse les fichiers .mod, affiche une interface tracker interactive et permet la lecture des samples audio avec visualisation waveform.

Repo : `levaleureux/dr_mod` (GitHub)
Rôle dans l'ecosysteme drgame : projet open source standalone avec lib reutilisable `dr_mod_tracker`.

## Structure

```
dr_mod/
├── app/
│   ├── main.rb                        # Point d'entree (charge DrMod, scenes, Game)
│   ├── scene.rb                       # Classe Scene de base (utilitaires couleur)
│   ├── tests.rb                       # Runner de tests (dr_spec)
│   ├── component/
│   │   ├── game.rb                    # Classe Game principale (init scenes, tick)
│   │   ├── pattern_player.rb          # Affichage & lecture de patterns
│   │   └── sfx_player.rb             # Lecteur audio par canal
│   └── scenes/
│       ├── concern.rb                 # Namespace module
│       ├── concerns/
│       │   ├── background.rb
│       │   ├── pattern_box.rb
│       │   └── sound_box.rb
│       ├── title.rb                   # Scene tracker (patterns, playback)
│       ├── sample.rb                  # Scene sample (visualisation waveform)
│       ├── game.rb                    # Scene game (minimale)
│       └── scene_manager.rb           # Gestion des transitions de scenes
│
├── lib/
│   ├── dr_spec/                       # Framework de test (copie locale)
│   └── dr_mod_tracker/                # Lib coeur du parsing MOD
│       ├── dr_mod.rb                  # Orchestrateur : charge MOD, song, samples, patterns
│       ├── dr_binary_file.rb          # Utilitaires fichier binaire
│       ├── dr_mod_byte.rb            # Manipulation d'octets
│       ├── load_tool.rb              # Decodage/offsets
│       ├── samples_loader.rb          # Chargement des samples
│       ├── song.rb                    # Metadonnees song (nom, longueur, patterns)
│       ├── pattern.rb                 # Pattern (64 lignes de cells)
│       ├── cell.rb                    # Cell (note, sample, effets)
│       ├── sample.rb                  # Sample audio + normalisation waveform
│       ├── song/
│       │   ├── song_setup.rb
│       │   └── song_print.rb
│       ├── pattern/
│       │   └── pattern_print.rb
│       ├── sample/
│       │   └── sample_print.rb
│       ├── tracker_formats/
│       │   └── protracker_1_1_b.rb    # Definition du format ProTracker 1.1B
│       ├── misc/
│       │   ├── read_mod.rb
│       │   ├── lire_mod.rb
│       │   └── xm_reader.rb
│       └── spec/                      # Tests de la lib
│           ├── dr_mod_spec.rb
│           ├── song_spec.rb
│           ├── cell_spec.rb
│           ├── dr_binary_file_spec.rb
│           └── fixture/
│               └── binary_file.rb
│
├── spec/                              # Tests applicatifs
│   ├── main_spec.rb
│   ├── matchers_1_spec.rb
│   ├── matchers_2_spec.rb
│   └── component/
│       └── game_spec.rb
│
├── metadata/                          # Metadonnees jeu
│   └── game_metadata.txt
├── sounds/                            # Fichiers audio (WAV notes, drums, MOD)
├── sprites/                           # Assets graphiques
├── fonts/                             # Polices
└── readme_files/                      # Images doc
```

## Architecture

### Lib dr_mod_tracker (parsing MOD)

Le coeur du projet est la lib `lib/dr_mod_tracker/` qui parse le format ProTracker 1.1B :

**Format MOD :**
- Header song : 1084 octets (nom 20 octets, 32 headers samples de 30 octets, longueur, positions, signature "M.K.")
- Pattern data : 1024 octets par pattern (64 lignes x 16 octets)
- Sample data : octets audio bruts (apres les patterns)

**Cell (4 octets) :**
- Octets 0-1 : numero sample + periode note (12 bits)
- Octet 2 : commande effet
- Octet 3 : argument effet

### Classes principales

| Classe | Fichier | Role |
|--------|---------|------|
| `DrMod` | `lib/dr_mod_tracker/dr_mod.rb` | Orchestrateur : charge MOD, song, samples, patterns |
| `Song` | `lib/dr_mod_tracker/song.rb` | Metadonnees song (nom, longueur, positions) |
| `Pattern` | `lib/dr_mod_tracker/pattern.rb` | Decode 64 lignes de cells |
| `Cell` | `lib/dr_mod_tracker/cell.rb` | Decodage binaire d'une cell |
| `Sample` | `lib/dr_mod_tracker/sample.rb` | Sample audio + normalisation |
| `Game` | `app/component/game.rb` | Boucle de jeu principale |
| `Scene::Title` | `app/scenes/title.rb` | Vue tracker/patterns |
| `Scene::Sample` | `app/scenes/sample.rb` | Vue sample + waveform |
| `PatternPlayer` | `app/component/pattern_player.rb` | UI pattern + lecture |
| `SfxPlayer` | `app/component/sfx_player.rb` | Lecture audio par canal |
| `SceneManager` | `app/scenes/scene_manager.rb` | Transitions de scenes |

### Pattern app DragonRuby

- Classe `Game` avec `attr_gtk` et methode `tick`
- `SceneManager` pour la navigation entre scenes (Title, Sample)
- Mixins `concerns/` pour decouper la logique des scenes (background, pattern_box, sound_box)

## Conventions de code

- **Nommage** : snake_case partout
- **Commentaires** : mix francais/anglais
- **Specs** : syntaxe dr_spec (`spec`, `it`, `context`, `before`, `expect(...).to`)
- **Blocs de test** : signature `do |args, assert|` (convention DragonRuby)

## Commandes

```bash
# Lancer dr_mod (depuis la racine drgame/)
./dragonruby-macos/dragonruby projects/dr_mod/mygame

# Lancer les tests
./dragonruby-macos/dragonruby projects/dr_mod/mygame --eval app/tests.rb --no-tick
```

## Assets audio

- **MOD** : `sounds/alex_menchi_-_xenon_3_miniblast.mod`, `sounds/falso_siddo.mod`
- **WAV** : notes individuelles (A3-C4), drums (kick, snare, cymbal), jazz samples

## Issues connues / TODOs

- Lecture audio des samples : problemes de frequence
- Scene management a refactorer
- Certaines methodes a extraire en modules
- Pattern 12 : problemes de lecture connus
- La lib dr_spec incluse est l'ancienne version (pre-refactoring class-based)

## Git — workflow git flow

- Remote : `git@github-valeureux.com:levaleureux/dr_mod.git`
- Identity : `levaleureux <133817850+levaleureux@users.noreply.github.com>`

### Branches

| Branche | Role |
|---------|------|
| `master` | Production stable. **Ne jamais commiter directement dessus.** |
| `develop` | Branche d'integration. Les features sont mergees ici. |
| `feature/*` | Branches de developpement, creees depuis `develop`. |

### Workflow

1. Creer une branche `feature/xxx` depuis `develop`
2. Developper et commiter sur la feature branch
3. Push + PR vers `develop`
4. Merge `develop` -> `master` pour les releases

**IMPORTANT** : ne jamais commiter ni push directement sur `master`. Toujours passer par `feature/* -> develop -> master`.
