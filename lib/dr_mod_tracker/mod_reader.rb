puts "let read a mod"
file = File.open("2min.xm", "rb")
contents = file.read

length, xm = contents.unpack("Sa*")

# [5, "hello"]
puts "========="
puts length
puts "========="

puts "====== xm reader ======="
# 0 17 char ID text 'Extended module: '
id_ext = xm[0, 17]
puts id_ext
# 17 20 char Module name 'Bellissima 99 (mix) '
module_name = xm[17, 20]
puts module_name
# 37 1 byte 0x1A 1A
# = xm[,]
# puts

# 38 20 char Tracker name 'FastTracker v2.00 '
traker_name = xm[38, 20]
puts traker_name

# 58 2 word Version number 04 01
version_num = xm[58,2]
puts "------"
puts version_num

# 60 4 dword Header size 14 01 00 00
# = xm[,]
# puts

# 64 2 word Song length 3E 00 (1..256)
# = xm[,]
# puts

# 66 2 word Restart position 00 00
# = xm[,]
# puts

# 68 2 word Number of channels 20 00 (0..32/64)
# = xm[,]
# puts

# 70 2 word Number of patterns 37 00 (1..256)
# = xm[,]
# puts

# 72 2 word Number of instruments 12 00 (0..128)
# = xm[,]
# puts

# 74 2 word Flags 01 00
# = xm[,]
# puts

# 76 2 word Default tempo 05 00
# = xm[,]
# puts

# 78 2 word Default BPM 98 00
# = xm[,]
# puts

# 80 ? byte Pattern order table 00 01 02 03 ...
# = xm[,]
# puts

