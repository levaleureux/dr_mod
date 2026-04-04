# Effect Dispatch Design — dr_mod

## Problem

ProTracker has 16+ effects (0x0-0xF) plus 16 extended effects (E0-EF).
Using `case/when` for dispatch creates long methods that grow with
each new effect and violate the 5-line rule.

## Solution: Hash-based dispatch

Effects are registered in constant hashes. Dispatch is a hash lookup
followed by `send`. Adding a new effect is one line in the hash +
one handler method.

```ruby
# Registration
GLOBAL_EFFECTS = {
  0xF => :set_speed_or_bpm,
  0xB => :position_jump,
  0xD => :pattern_break,
}.freeze

CHANNEL_EFFECTS = {
  0xC => :set_channel_volume,
}.freeze

# Dispatch
def apply_global_effect
  handler = GLOBAL_EFFECTS[@effect_command]
  send(handler, @effect_argument) if handler
end
```

## Two categories

### Global effects
Affect the whole song: tempo changes, navigation jumps.
Handlers receive `@effect_argument` only.

| Code | Handler | What it does |
|------|---------|-------------|
| 0xF | set_speed_or_bpm | Speed (1-31) or BPM (32+) |
| 0xB | position_jump | Jump to song position |
| 0xD | pattern_break | End pattern, jump to line |

### Channel effects
Affect a single channel: volume, pitch, modulation.
Handlers receive `@current_channel` and `@effect_argument`.

| Code | Handler | What it does |
|------|---------|-------------|
| 0xC | set_channel_volume | Set volume directly (0-64) |

## Instance variables as context

Instead of passing cell data through parameters, the dispatcher
sets instance variables before calling handlers:

```ruby
def dispatch_effects cell, ch
  @effect_command  = cell.effect_command
  @effect_argument = cell.effect_argument
  @current_channel = ch
  apply_global_effect
  apply_channel_effect
end
```

This keeps handler signatures simple and avoids long parameter lists.

## Adding a new effect

1. Implement the handler method:
```ruby
def set_volume_slide ch, value
  # ...
end
```

2. Register in the appropriate hash:
```ruby
CHANNEL_EFFECTS = {
  0xC => :set_channel_volume,
  0xA => :set_volume_slide,   # ← new
}.freeze
```

3. Write a test.

No dispatcher code changes needed. Open/closed principle.

## Trade-offs

**Pros:**
- Open/closed: new effects don't modify dispatch logic
- Clean: no growing case/when chains
- Discoverable: all effects listed in one place (the hash)
- Testable: each handler is an independent method

**Cons:**
- Slightly less readable than case/when for small effect counts
- `send` is dynamic dispatch — typos in handler names fail at runtime
- Instance variables as context couples the dispatcher to the handlers

For this project, the extensibility wins — there are 30+ effects to implement.
