# MOD File Layout: Two Offset Bugs That Corrupted Every Sample

## The MOD File Memory Map

A ProTracker .mod file is laid out sequentially in memory:

```
Offset    Size     Content
0         20       Song name
20        930      31 sample headers (30 bytes each)
950       1        Song length
951       1        Tracker byte
952       128      Song position table
1080      4        Format signature ("M.K.")
1084      N*1024   Pattern data (N patterns, 1024 bytes each)
1084+N*1024  ...   Sample audio data (concatenated)
```

The sample audio data starts right after the last pattern.
To find it, you need to know how many patterns there are.

## Bug #1: Amiga Words vs Bytes

The sample header stores lengths in **Amiga words** (2-byte units):

```
Offset  Size  Description
42      2     Sample length (in words, multiply by 2 for bytes)
46      2     Repeat point (in words)
48      2     Repeat length (in words)
```

Our parser read the raw value without multiplying:

```ruby
# Before (wrong): length in words, not bytes
@length = decode_amiga_word(@mod_data, offset)

# After (correct): convert words to bytes
@length = decode_amiga_word(@mod_data, offset) * 2
```

**Effect:** Each sample read half its actual data. The waveform showed
the real sample followed by the beginning of the next sample.

## Bug #2: Pattern Count Off-By-One

To find where sample data starts, we calculate:

```ruby
def samples_start_at
  1084 + (pattern_count * 1024)
end
```

`pattern_count` was computed from the song position table:

```ruby
# Before (wrong): max index, not count
def pattern_count
  @song_positions.max  # returns 17 for patterns 0..17
end

# After (correct): count = max index + 1
def pattern_count
  @song_positions.max + 1  # returns 18
end
```

**Effect:** The sample data offset was 1024 bytes too early,
pointing into the last pattern instead of the actual sample data.
Every sample started with 1024 bytes of pattern data garbage.

## Combined Effect

With both bugs active:
- Sample data started 1024 bytes too early (pattern data leak)
- Each sample read only half its bytes
- The cumulative offset for subsequent samples was also halved
- Result: every sample was a mix of wrong data from wrong locations

## Visual Evidence

The waveform visualization made it obvious: you could see two distinct
wave patterns in each sample — the real audio mixed with data from
adjacent samples or pattern data.

## Lesson

Binary format parsers need two things:
1. **Unit awareness** — always check if values are in bytes, words,
   or some other unit. The Amiga loved 16-bit words.
2. **Fence post counting** — "the highest index" and "the count"
   differ by one. This is the oldest bug in programming.

Both bugs had the same root cause: reading the ProTracker spec too
quickly and missing the conversion details.
