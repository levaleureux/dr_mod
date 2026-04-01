# Architecture — dr_mod

> This document must be updated when classes, modules, or
> relationships change. See CLAUDE.md for the reminder.

## Overview

dr_mod has three layers: **App** (DragonRuby game loop, scenes, UI),
**Components** (player engines), and **Lib** (MOD file parsing).

## Class Diagram

```mermaid
classDiagram
    direction TB

    %% === App Layer ===

    class Game {
        +tick()
        -scene_manager
    }

    class Scene {
        +color_btn()
        +color_header()
    }

    class Title {
        +tick()
        -init_dr_mod()
        -reload_mod()
    }

    class Sample {
        +tick()
        -show_text()
    }

    class SceneManager {
        +tick()
    }

    Scene <|-- Title
    Scene <|-- Sample
    Game --> SceneManager
    Game --> Title
    Game --> Sample

    %% === Concerns ===

    class Background {
        <<module>>
        +draw_screen_box()
        +init_dr_mod()
        MOD_FILES
    }

    class SoundBox {
        <<module>>
        +sound_section()
        -handle_playback_keys()
        -octave_key_fr()
    }

    class PatternBox {
        <<module>>
    }

    Title ..|> Background : includes
    Title ..|> PatternBox : includes
    Sample ..|> SoundBox : includes

    %% === Components ===

    class PatternPlayer {
        +tick()
        -handle_input()
        -clamp_position()
        @loop_pattern
        @muted_channels
    }

    class PatternDraw {
        <<module>>
        -pattern_section()
        -render_line()
        -render_current_line()
    }

    class PatternSideBar {
        <<module>>
        -side_bar()
        -draw_shortcuts()
        -draw_channel_info()
    }

    class PatternAudio {
        <<module>>
        -play_row_sounds()
        -amiga_rate()
        -finetune_factor()
    }

    PatternPlayer ..|> PatternDraw : includes
    PatternPlayer ..|> PatternSideBar : includes
    PatternPlayer ..|> PatternAudio : includes
    Title --> PatternPlayer : creates

    class SfxPlayer {
        +start()
        +stop()
        +custom_rate()
        AMIGA_PAL_FREQ
        C3_PERIOD
    }

    class SfxDraw {
        <<module>>
        -draw_waveform()
        -draw_wave_segments()
        -tick_draw()
    }

    SfxPlayer ..|> SfxDraw : includes
    Title --> SfxPlayer : creates 4x channels

    %% === Lib Layer (dr_mod_tracker) ===

    class DrMod {
        +load_all()
        @song
        @samples
        @patterns
    }

    class Song {
        +pattern_count()
        +samples_start_at()
        @name
        @song_positions
    }

    class SongSetup {
        <<module>>
        -set_name()
        -set_length()
        -set_song_positions()
    }

    class Pattern {
        +decode_rows()
        @rows
    }

    class Cell {
        @sample_number
        @note_period
        @effect_command
        @effect_argument
    }

    class CellBin {
        <<module>>
        +read_sample_number()
    }

    class CellInfo {
        <<module>>
        +info()
        +info_verbose()
    }

    class SampleClass["Sample"] {
        +decode_data()
        +normalized()
        @finetune
        @volume
        @length
    }

    class SamplesLoader {
        +load()
        SAMPLE_COUNT = 31
    }

    class LoadTool {
        <<module>>
        +decode_amiga_word()
    }

    class PatternPrint {
        <<module>>
        +row_info()
    }

    DrMod --> Song : creates
    DrMod --> SamplesLoader : creates
    DrMod --> Pattern : creates
    SamplesLoader --> SampleClass : creates 31x
    Pattern --> Cell : creates 64x4
    Song ..|> SongSetup : includes
    Song ..|> LoadTool : includes
    Pattern ..|> PatternPrint : includes
    Pattern ..|> LoadTool : includes
    Cell ..|> CellBin : includes
    Cell ..|> CellInfo : includes
    Cell ..|> LoadTool : includes
    SampleClass ..|> LoadTool : includes

    Background --> DrMod : uses
    PatternAudio --> SampleClass : reads
    PatternAudio --> Cell : reads
    SfxPlayer --> SampleClass : reads
```

## Data Flow

### MOD File Loading

```
MOD binary file
    │
    ▼
DrMod.load_all
    ├── Song (header: name, positions, length)
    ├── Pattern × N (64 rows × 4 cells each)
    │       └── Cell (sample_number, note_period, effects)
    └── Sample × 31 (header + audio data)
            └── normalized_data (float array -1.0..1.0)
```

### Audio Playback

```
Pattern row → Cell (note_period, sample_number)
    │
    ▼
PatternAudio.amiga_rate(period, finetune)
    hz = 7093789.2 / (period * 2) × 2^(finetune/96)
    │
    ▼
one_shot_lambda → sample.normalized_data (once)
    │
    ▼
args.audio[:channel_N] = { input: [1, rate, lambda], gain: vol/64 }
```

### Scene Navigation

```
Game.tick
    │
    ▼
SceneManager
    ├── Title (tracker view) ──[S]──► Sample (waveform view)
    │       ▲                              │
    │       └──────────[C]─────────────────┘
    │
    └── Controls:
        Space: play/pause    M: sound on/off
        L: loop pattern      1-4: mute channels
        F5: reload MOD       R: reset
```

## Module Responsibilities

| Module | Role | Used by |
|--------|------|---------|
| LoadTool | Binary parsing (Amiga word decode) | Song, Pattern, Cell, Sample |
| CellBin | Cell byte decoding (sample number) | Cell |
| CellInfo | Cell display formatting | Cell |
| SongSetup | Song header parsing | Song |
| PatternPrint | Pattern console output | Pattern |
| SamplePrint | Sample console output | Sample |
| PatternDraw | Pattern grid rendering | PatternPlayer |
| PatternSideBar | Sidebar UI | PatternPlayer |
| PatternAudio | MOD sample playback | PatternPlayer |
| SfxDraw | Waveform rendering | SfxPlayer |
| Background | Screen borders, MOD loading | Title |
| SoundBox | Playback controls, keyboard | Sample |

## Key Constants

| Constant | Value | Location |
|----------|-------|----------|
| AMIGA_PAL_FREQ | 7,093,789.2 Hz | SfxPlayer |
| C3_PERIOD | 214 | SfxPlayer |
| SAMPLE_COUNT | 31 | SamplesLoader |
| MOD_FILES | test .mod paths | Background |
| WAV_SAMPLES | legacy WAV names | PatternAudio |
