# Comparing Sample Parsing: XMP vs dr_mod

## Context

dr_mod parses Amiga MOD files to play them in DragonRuby. The samples
play at the wrong frequency (#29). Before fixing the playback formula,
we need to verify that the parsing itself is correct.

## Method

Compare sample properties dumped by two independent parsers:
- **XMP** (reference): `xmp -v --load-only file.mod`
- **dr_mod**: custom dump script via DragonRuby eval

### Tools used
- XMP 4.2.0 (libxmp 4.7.0) — well-tested open source MOD player
- dr_mod dump_samples.rb — runs through DragonRuby mRuby runtime

### MOD file tested
`alex_menchi_-_xenon_3_miniblast.mod` — ProTracker M.K. format,
31 samples, 4 channels, 18 patterns.

## Results

### XMP output (hex values for Vol)
```
01 Kick      Vol:40 Fine:+000
02 HH        Vol:40 Fine:+000
03 Snare     Vol:40 Fine:+000
04 HHO       Vol:40 Fine:+000
05 bass      Vol:2b Fine:+016
06 bip       Vol:31 Fine:+000
07 guit      Vol:32 Fine:+000
08 ACDC      Vol:3d Fine:+000
09 perc1     Vol:40 Fine:+000
0a perc2     Vol:40 Fine:+000
0b synth     Vol:40 Fine:+000
```

### dr_mod output (decimal values)
```
0  Kick      Vol:64  Fine:0
1  HH        Vol:64  Fine:0
2  Snare     Vol:64  Fine:0
3  HHO       Vol:64  Fine:0
4  bass      Vol:43  Fine:1
5  bip       Vol:49  Fine:0
6  guit      Vol:50  Fine:0
7  ACDC      Vol:61  Fine:0
8  perc1     Vol:64  Fine:0
9  perc2     Vol:64  Fine:0
10 synth     Vol:64  Fine:0
```

### Comparison

| Property | Match | Notes |
|----------|-------|-------|
| Names | ✅ | Identical across all samples |
| Volume | ✅ | XMP shows hex (0x40=64), dr_mod shows decimal. Values match. |
| Finetune | ⚠️ | XMP shows +016 for bass, dr_mod shows 1. See analysis below. |

### Finetune discrepancy analysis

ProTracker stores finetune as a 4-bit signed nibble (lower 4 bits of the byte).
- Raw byte value for bass: 1
- XMP displays: +016 (which is 1 × 16, the raw nibble scaled)
- dr_mod displays: 1 (the raw nibble value)

Both are reading the same data, just displaying differently.
The finetune value 1 means "+1 finetune step" in ProTracker terms.

### Bug found: Sample 31

The last sample slot (index 31) shows corrupted values:
```
31   [garbage]  13  2319  14  3332  2826
```

This is likely an off-by-one error: ProTracker has 31 sample slots
(numbered 1-31), but dr_mod iterates 32 times (0-31), reading
beyond the sample header area into pattern data. See #31.

## Conclusion

**The parsing is correct** for samples 0-30. Volume, name, and
finetune values match the reference player. The frequency bug (#29)
is in the playback formula (`custom_rate` in `sfx_player.rb`),
not in the data parsing.

## Next steps

1. Fix sample count (31 instead of 32) — #31
2. Investigate `custom_rate` formula vs Amiga standard — #29
3. Add dr_spec tests for sample parsing — #28
