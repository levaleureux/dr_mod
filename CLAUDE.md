# dr_mod - Lecteur de fichiers Amiga MOD pour DragonRuby

## Description

dr_mod est un loader/player de fichiers audio Amiga MOD (format ProTracker 1.1B) pour DragonRuby Game Toolkit.
Il parse les fichiers .mod, affiche une interface tracker interactive et permet la lecture des samples audio avec visualisation waveform.

Repo : `levaleureux/dr_mod` (open source, GitHub)

## Structure

```
dr_mod/
├── app/                        # Code applicatif DragonRuby
│   ├── main.rb                 # Point d'entree
│   ├── tests.rb                # Runner de tests (dr_spec)
│   ├── component/              # Game, PatternPlayer, SfxPlayer
│   └── scenes/                 # Title (tracker), Sample (waveform), SceneManager
├── lib/
│   ├── dr_spec/                # Framework de test (copie locale)
│   └── dr_mod_tracker/         # Lib coeur du parsing MOD
│       ├── dr_mod.rb           # Orchestrateur principal
│       ├── song.rb, pattern.rb, cell.rb, sample.rb
│       └── spec/               # Tests unitaires de la lib
├── spec/                       # Tests applicatifs
├── sounds/                     # Fichiers MOD et samples WAV
├── bin/                        # Wrappers rubocop/reek pour lefthook
├── lefthook.yml                # Hooks pre-commit
└── metadata/                   # Metadonnees DragonRuby
```

## Commandes

```bash
# Lancer dr_mod (depuis la racine drgame/)
../../dragonruby-macos/dragonruby projects/dr_mod

# Lancer les tests
../../dragonruby-macos/dragonruby projects/dr_mod --eval app/tests.rb --no-tick
```

## Workflow

### Git Flow

On utilise **git flow** avec les branches suivantes :

| Branche      | Role                                                     |
|--------------|----------------------------------------------------------|
| `master`     | Production stable. **Ne jamais commiter directement.**   |
| `develop`    | Branche d'integration. Les features sont mergees ici.    |
| `feature/*`  | Branches de developpement, creees depuis `develop`.      |

**Cycle de travail :**
1. Creer une branche `feature/xxx` depuis `develop`
2. Developper et commiter sur la feature branch
3. Push + PR vers `develop`
4. Merge `develop` -> `master` pour les releases

### Issues GitHub

On utilise les **issues GitHub** (`levaleureux/dr_mod`) pour tracker le travail :
- Chaque tache ou bug a une issue dediee
- Les PRs referencent leur issue (`#N`)
- Les branches de feature correspondent a une issue quand c'est pertinent

### Lefthook (pre-commit)

Le projet utilise **lefthook** pour garantir la qualite du code avant chaque commit :

- **rubocop** (`bin/rubocop_quiet`) : lint sur `app/` et `lib/dr_mod_tracker/`. Bloquant.
- **reek** (`bin/reek_quiet`) : detection de code smells. Non bloquant (avertissements).

Les wrappers `bin/` produisent une sortie condensee, adaptee a un agent IA.
Lefthook aide l'agent a produire du code stable en bloquant les commits non conformes.

## Etape actuelle

**Priorite : stabiliser le projet**

1. **Fixer les bugs** — notamment la lecture audio des samples (frequence incorrecte) et les problemes de parsing sur certains patterns
2. **Consolider le flow lefthook** — rubocop + reek en pre-commit pour que chaque commit respecte les standards de qualite

L'objectif est d'avoir une base saine avant d'entamer le refactoring Sandi Metz (petites classes, petites methodes, code lisible et exemplaire).

## Conventions

- **DragonRuby** : classe `Game` avec `attr_gtk`, `SceneManager` pour les scenes
- **Nommage** : snake_case
- **Style de code** : voir `doc/code_style.md` — anti-parentheses, conventions mRuby
- **Tests** : syntaxe dr_spec (`spec`, `it`, `context`, `before`, `expect(...).to`)
- **Git** : identity `levaleureux <133817850+levaleureux@users.noreply.github.com>`
- **Remote** : `git@github-valeureux.com:levaleureux/dr_mod.git`

## Verification apres changement

Toujours lancer le jeu visuellement apres un fix, pas seulement les tests.
Il y a peu de tests pour le moment, la verification visuelle est indispensable.

```bash
# Lancer le jeu (depuis dr_mod/)
../../dragonruby-macos/dragonruby projects/dr_mod
```
