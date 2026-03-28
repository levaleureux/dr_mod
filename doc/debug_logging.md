# Debug & Logging — dr_mod

## Status: draft (see #23)

## Problem

Scattered `puts` calls throughout the codebase for debugging.
They pollute the console in production and inflate method length
(triggering rubocop MethodLength offenses).

## Direction

A simple `DebugLog` module with a toggle flag.

```ruby
module DebugLog
  ENABLED = false # set to true during development

  def log category, msg
    puts "[#{category}] #{msg}" if ENABLED
  end
end
```

### Usage

```ruby
class SfxPlayer
  include DebugLog

  def initialize args, mod, channel = :channel_0
    @channel = channel
    log :audio, "channel: #{@channel}"
    # ...
  end
end
```

### Categories (draft)

| Category | Usage |
|----------|-------|
| `:audio` | SfxPlayer, playback, sample rate |
| `:loading` | SamplesLoader, DrMod, file parsing |
| `:scene` | Scene transitions, state changes |
| `:draw` | Waveform, UI rendering |

### Rules

- `puts` for debug → replace with `log :category, msg`
- `puts` for user-facing output → keep as `puts`
- Log calls go in dedicated private methods when there are 2+ lines
- ENABLED = false in production (committed as false)

### Future

- Per-category toggle (e.g. `ENABLED_CATEGORIES = [:audio]`)
- Log to file option
- DragonRuby console integration
