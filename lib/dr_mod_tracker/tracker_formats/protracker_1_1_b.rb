#
#
# https://www.lim.di.unimi.it/IEEE/VROS/FAQ/CRAMIG2.HTM
#
#
PROTRACKER_1_1_B = {
  song_name: {
    offset:  0,
    bytes:   20,
    desc:    "Songname. Remember to put trailing null bytes at the end..."
  },
  is_mk: {
    offset:  1080,
    bytes:   4,
    desc:    "The four letters 'M.K.' - This is something
Mahoney & Kaktus     inserted when they increased
the number of samples from 15 to 31. If it's not there,
the module/song uses 15 samples or the text has been
removed to make the module harder to rip.
  Star trekker puts 'FLT4' or 'FLT8' there instead.  "
  },
  #Information for the next 30 samples starts here. It's just like the info forsample 1.
  #
  # Offset Bytes Description
  # 50     30    Sample 2...
  # 80     30    Sampl            e 3...
  # .
  #
  # .
  #
  # .
  #
  # 890    30    Sample 30...
  # 920    30    Sample 31...
  #
  sample_name: {
    offset:  20,
    bytes:   22,
    desc:    "Samplename for sample 1.\nPad with null bytes."
  },
  sample_length: {
    offset:  42,
    bytes:   2,
    desc:    "Samplelength for sample 1.\nStored as number of words.\nMultiply by two to get real sample length in bytes."
  },
  finetune: {
    offset:  44,
    bytes:   1,
    desc:    "Lower four bits are the finetune value,\nstored as a signed four bit number.\nThe upper four bits are not used,\nand should be set to zero.\nValue:  Finetune:  \n0  0\n1  +1\n2  +2\n3  +3\n4  +4\n5  +5\n6  +6\n7  +7\n8  -8\n9  -7\nA  -6\nB  -5\nC  -4\nD  -3\nE  -2\nF  -1"
  },
  volume: {
    offset:  45,
    bytes:   1,
    desc:    "Volume for sample 1.\nRange is $00-$40, or 0-64 decimal."
  },
  repeat_point: {
    offset:  46,
    bytes:   2,
    desc:    "Repeat point for sample 1.\nStored as number of words offset\nfrom start of sample.\nMultiply by two to get offset in bytes."
  },
  repeat_length: {
    offset:  48,
    bytes:   2,
    desc:    "Repeat Length for sample 1.\nStored as number of words in loop.\nMultiply by two to get replen in bytes."
  },
  # Song
  song_length: {
    offset:  950,
    bytes:   1,
    desc:    "Songlength. Range is 1-128."
  },
  tracker_byte: {
    offset:  951,
    bytes:   1,
    desc:    "Well... this little byte here is set to 127, so that old trackers will search through all patterns when loading. Noisetracker uses this byte for restart, but we don't."
  },
  song_positions: {
    offset:  952,
    bytes:   128,
    desc:    "Song positions 0-127. Each hold a number from 0-63 that tells the tracker what pattern to play at that position."
  },
  format_signature: {
    offset:  1080,
    bytes:   4,
    desc:    "The four letters 'M.K.' - This is something Mahoney & Kaktus inserted when they increased the number of samples from 15 to 31. If it's not there, the module/song uses 15 samples or the text has been removed to make the module harder to rip. Star trekker puts 'FLT4' or 'FLT8' there instead."
  },
  # Pattern
  pattern_data: {
    offset:  1084,
    bytes:   1024,
    desc:    "Data for pattern 00..."
  },
  num_patterns: {
    offset:  "xxxx",
    desc:    "Number of patterns stored is equal to the highest pattern number in the song position table (at offset 952-1079)."
  },
  # Periodtable for Tuning 0, Normal
  # C-1 to B-1 : 856,808,762,720,678,640,604,570,538,508,480,453
  # C-2 to B-2 : 428,404,381,360,339,320,302,285,269,254,240,226
  # C-3 to B-3 : 214,202,190,180,170,160,151,143,135,127,120,113
  notes: {
    # 1
    856 => 'C-1',
    808 => 'C#1',
    762 => 'D-1',
    720 => 'D#1',
    678 => 'E-1',
    640 => 'F-1',
    604 => 'F#1',
    570 => 'G-1',
    538 => 'G#1',
    508 => 'A-1',
    480 => 'A#1',
    453 => 'B-1',
    # 2
    428 => 'C-2',
    404 => 'C#2',
    381 => 'D-2',
    360 => 'D#2',
    339 => 'E-2',
    320 => 'F-2',
    302 => 'F#2',
    285 => 'G-2',
    269 => 'G#2',
    254 => 'A-2',
    240 => 'A#2',
    226 => 'B-2',
    # 3
    214 => 'C-3',
    202 => 'C#3',
    190 => 'D-3',
    180 => 'D#3',
    170 => 'E-3',
    160 => 'F-3',
    151 => 'F#3',
    143 => 'G-3',
    135 => 'G#3',
    127 => 'A-3',
    120 => 'A#3',
    113 => 'B-3'
  }
}
