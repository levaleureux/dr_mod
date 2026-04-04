# ProTracker Sample Indexing: Why Sample 0 Doesn't Exist

## The Off-By-One That Haunts Every MOD Parser

If you're writing a MOD file parser, you'll hit this bug. We did.

## The Convention

In ProTracker (and all Amiga MOD formats), samples are numbered **1 to 31**.
Sample **0** means "no instrument" — the channel keeps its current state.

```
Sample 0: No instrument (silence or sustain previous)
Sample 1: First real instrument (e.g. Kick)
Sample 2: Second instrument (e.g. HH)
...
Sample 31: Last instrument
```

## Why Zero Means Nothing

This is a design choice from the original Soundtracker (Karsten Obarski, 1987).
The sample number is encoded in the pattern data alongside the note period.
When a tracker encounters sample 0 with a valid note period, it means
"apply an effect to the current channel without triggering a new sample."

Common uses of sample 0:
- Volume slides without retriggering
- Portamento (pitch bend) on the current note
- Effect-only cells

It's the same principle as null/nil in programming — a marker of absence.

## The Bug

In Ruby, arrays are 0-indexed. The MOD file has 31 sample headers
starting at byte 20. When you parse them:

```ruby
32.times do |num|
  @samples.push Sample.new(num, mod_data)
  # num=0 reads header at offset 0*30=0 → this is sample "1" (Kick)
  # num=1 reads header at offset 1*30=30 → this is sample "2" (HH)
end
```

So `@samples[0]` is the Kick (ProTracker sample 1).

When the pattern data says "play sample 1", if you do:
```ruby
@mod.samples[cell.sample_number]  # sample_number=1 → HH (wrong!)
```

You get the HH instead of the Kick. Every instrument is shifted by one.

## The Fix

```ruby
# Filter out "no instrument" cells
return if cell.sample_number == 0

# ProTracker 1-indexed → Ruby 0-indexed
s = @mod.samples[cell.sample_number - 1]
```

## How We Found It

The pattern player was playing sounds that didn't match the expected
instruments. A kick line was playing a hi-hat, bass lines were playing
something else. Once we understood the ProTracker convention, the
off-by-one was obvious.

## Lesson

When parsing a format from the 1980s, always check if indices start
at 0 or 1. The Amiga demoscene used 1-based indexing for many things
(samples, patterns), while modern languages use 0-based arrays.
Document the convention explicitly in your code.
