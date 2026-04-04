# Audio Debug Methodology — dr_mod

## Status: draft (see #29)

## Goal

Compare dr_mod audio output with a reference MOD player to identify
where the frequency/pitch calculation diverges.

## Tools

- **XMP** (`brew install xmp`) — CLI MOD player, good for quick playback
- **MilkyTracker** (`brew install --cask milkytracker`) — visual tracker,
  shows sample properties and plays notes accurately

## Reference MOD file

`sounds/alex_menchi_-_xenon_3_miniblast.mod`

## Step 1: Verify sample data integrity

Compare sample properties between dr_mod and MilkyTracker:
- Open the .mod file in MilkyTracker
- For each sample, note: name, length, finetune, volume, repeat point
- Compare with dr_mod output (Sample view shows these values)
- If values differ → parsing bug
- If values match → the data is correct, problem is in playback

## Step 2: Verify frequency calculation

The Amiga period-to-Hz formula:
```
hz = 7093789.2 / (period * 2)
```

For example, note C-3 has period 214:
```
hz = 7093789.2 / (214 * 2) = 16575.2 Hz
```

Check what dr_mod computes:
- `init_sample_rate` : base rate = `(70937892 / (856 * 2))` = 41453 Hz
- `custom_rate` : rate used for playback
- Compare these values with the expected Hz for a given note

## Step 3: Verify DragonRuby audio API usage

DragonRuby audio input format:
```ruby
args.audio[channel] = {
  input: [num_channels, sample_rate, lambda_that_returns_samples]
}
```

Questions to verify:
- Is `sample_rate` the playback rate or the source rate?
- Does DragonRuby expect normalized floats (-1.0..1.0) or raw bytes?
- Is the lambda called once or repeatedly?

## Step 4: Isolated test

Create a simple test:
- One known sample (e.g. a sine wave at 440 Hz)
- Play it in dr_mod and in XMP/MilkyTracker
- Compare pitch by ear or with a tuner app

## Step 5: Fix and verify

Once the formula is corrected:
- Play the full MOD in XMP: `xmp sounds/alex_menchi_-_xenon_3_miniblast.mod`
- Play the same in dr_mod
- Compare patterns/samples side by side
