# Changelog

All notable changes to dr_mod are documented in this file.

## [0.2.1] — 2026-04-04

### Fixed
- Reload key: F5 not a valid DR key name, changed to W
- Channel mute keys 1-4: DR uses word names (one, two, three, four)
- Effect 0xF Set Speed/BPM: correct Amiga-to-DR tempo conversion

### Added
- PatternTempo module: Amiga CIA tick → DR frame conversion
- PatternInput module: keyboard handling extracted
- 5 tempo conversion tests (58 total)

## [0.2.0] — 2026-04-04

### Fixed
- **Sample data corruption**: Amiga word-to-byte conversion (×2 missing) and
  pattern_count off-by-one caused every sample to read wrong data (#33)
- **Sample frequency**: replaced broken custom_rate with Amiga PAL formula
  `hz = 7093789.2 / (period * 2)` (#29)
- **Sample looping**: one-shot lambda prevents infinite playback loop
- **Sample indexing**: ProTracker 1-indexed samples (0 = no instrument) (#31)
- **Finetune parsing**: signed 4-bit (-8 to +7), was read as unsigned (#34)
- **Finetune applied**: frequency adjusted by `2^(finetune/96)` (#34)
- **Sample volume**: mapped ProTracker 0-64 to DragonRuby gain 0.0-1.0 (#35)
- **Visual alignment**: colored bands now aligned with pattern text (#20)
- **DR 6.x compatibility**: replaced dynamic load_dep_files with explicit requires (#41)

### Added
- **Pattern loop mode**: press L to repeat current pattern (#45)
- **Channel mute/unmute**: press 1-4 to toggle channels (#44)
- **Hot reload MOD**: press F5 to reload MOD file without restart (#36)
- **Sidebar shortcuts**: display current key bindings and state
- **53 unit tests**: Cell, LoadTool, Sample, Song parsing (was 4) (#28)
- **GitHub Actions CI**: rubocop + reek lint on push/PR (#40)
- **Lefthook pre-commit**: rubocop + reek + dr_spec (#15)
- **Architecture docs**: Mermaid class diagram and data flow (#24)
- **Code style guide**: anti-parentheses, Sandi Metz rules (#14)
- **Reek config**: adapted for DragonRuby patterns (#27)
- **Blog drafts**: MOD file layout bugs, ProTracker finetune, sample indexing,
  lefthook-driven refactoring with AI

### Changed
- **Rubocop**: 93 → 0 offenses (#14)
- **Reek**: 124 → 32 warnings (#27)
- **Pattern player**: uses real MOD samples instead of hardcoded WAV files
- **6 modules extracted**: CellInfo, SfxDraw, PatternDraw, PatternSideBar,
  PatternAudio, SfxDraw (Sandi Metz: 5 lines/method, 100 lines/class)
- **README**: updated with all controls, git flow, dev setup

### Removed
- Dead code: start_game, sine_wave lambda, debug puts
- Floating methods outside Cell class
- Dynamic `load_dep_files` (DR 6.x incompatible)

## [0.1] — 2024

Initial version. Basic MOD file loading, pattern display, sample view.
