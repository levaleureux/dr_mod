# ProTracker Tempo: Converting Amiga Ticks to DragonRuby Frames

## The Problem

ProTracker runs on the Amiga's CIA timer at a variable tick rate.
DragonRuby runs a fixed game loop at 60 FPS. How do we map one
to the other so the music plays at the correct speed?

## Amiga Timing

ProTracker has two timing parameters:

- **Speed** (1-31): how many ticks per pattern line
- **BPM** (32+): beats per minute, controls the tick rate

The CIA timer generates ticks at:
```
tick_rate = bpm * 2 / 5   (ticks per second)
```

Default BPM is 125 (PAL standard):
```
tick_rate = 125 * 2 / 5 = 50 ticks/second   (= PAL refresh rate)
```

A pattern line plays every `speed` ticks:
```
time_per_line = speed / tick_rate   (seconds)
```

Default speed is 6:
```
time_per_line = 6 / 50 = 0.12 seconds per line
```

## DragonRuby Conversion

DragonRuby runs at 60 FPS. We need frames per line:
```
frames_per_line = 60 * time_per_line
                = 60 * speed / tick_rate
                = 60 * speed / (bpm * 2 / 5)
                = 60 * speed * 5 / (bpm * 2)
                = (60 * speed * 2.5) / bpm
```

### Examples

| Speed | BPM | Amiga lines/sec | DR frames/line | Feel |
|-------|-----|-----------------|----------------|------|
| 6 | 125 | 8.3 | 7 | Normal (default) |
| 3 | 125 | 16.7 | 4 | Fast |
| 12 | 125 | 4.2 | 14 | Slow |
| 6 | 150 | 10.0 | 6 | Faster BPM |
| 6 | 80 | 5.3 | 11 | Slower BPM |
| 1 | 125 | 50.0 | 1 | Maximum speed |

## Effect 0xF: Set Speed / Set BPM

The effect command 0xF uses the argument to set either speed or BPM:

- **Argument 1-31**: sets speed (ticks per line)
- **Argument 32+**: sets BPM (beats per minute)
- **Argument 0**: ignored

Both trigger a recalculation of `frames_per_line`.

```ruby
def set_speed_or_bpm value
  return if value == 0
  if value < 32
    @speed = value
  else
    @bpm = value
  end
  @frames_per_line = compute_frames_per_line
end

def compute_frames_per_line
  ((60 * @speed * 2.5) / @bpm).round
end
```

## Why .round and Not .to_i?

With `.to_i` (truncation), speed=6 bpm=125 gives 7 (from 7.2).
With `.round`, same gives 7. But for other values:

- speed=4 bpm=125: 4.8 → `.to_i`=4, `.round`=5
- The rounded value is closer to the intended Amiga timing.

## Historical Note

The dual speed/BPM system exists because early trackers (SoundTracker,
NoiseTracker) only had speed (1-31). When ProTracker added BPM support,
they reused the same effect command with a threshold at 32 to maintain
backward compatibility. That's why the magic number 32 separates the
two modes — it's the minimum BPM that makes musical sense.
