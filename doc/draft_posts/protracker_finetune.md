# ProTracker Finetune: Micro-Tuning Samples

## What is Finetune?

In ProTracker, each sample has a **finetune** value that slightly adjusts
its pitch. It's a micro-tuning control — when a sample was recorded
slightly sharp or flat, the finetune corrects it without re-recording.

## Storage

Finetune is stored as **1 byte** in the sample header (offset 44).
Only the lower 4 bits are used. The value is **signed**:

```
Raw value:  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
Finetune:   0 +1 +2 +3 +4 +5 +6 +7 -8 -7 -6 -5 -4 -3 -2 -1
```

Values 0-7 are positive, 8-15 are negative (two's complement on 4 bits).

## Effect on Pitch

Each finetune step shifts the pitch by **1/8 of a semitone**.
There are 12 semitones in an octave, so the full finetune range
(-8 to +7) covers about ±1 semitone.

## The Formula

To apply finetune to a playback frequency:

```
adjusted_hz = base_hz * 2^(finetune / 96)
```

Where 96 = 12 semitones × 8 finetune steps per semitone.

### Example

Sample "bass" has finetune = +1 (raw value 1 in the MOD file):

```
base_hz (C-3) = 7093789.2 / (214 * 2) = 16575 Hz
factor        = 2^(1/96) = 1.00724
adjusted_hz   = 16575 * 1.00724 = 16695 Hz
```

A subtle shift — about 12 cents, barely perceptible on its own
but important when multiple samples play together.

## Implementation in dr_mod

### Parsing (sample.rb)

```ruby
# Lower 4 bits, signed: 0-7 positive, 8-15 negative
raw = byte & 0x0F
@finetune = raw > 7 ? raw - 16 : raw
```

### Playback (pattern_audio.rb, sfx_player.rb)

```ruby
def amiga_rate period, finetune = 0
  base = AMIGA_PAL_FREQ / (period * 2)
  (base * finetune_factor(finetune)).to_i
end

def finetune_factor finetune
  2 ** (finetune / 96.0)
end
```

## Why It Matters

Most MOD files have finetune = 0 on all samples. But some composers
use finetune to:
- Correct slightly out-of-tune recordings
- Create detuned effects (chorus-like)
- Match samples that were recorded at different pitches

Without finetune support, these MODs sound subtly wrong —
instruments don't blend together as intended.
