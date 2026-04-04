# Cell parsing specs
#
# ProTracker cell format: 4 bytes
# Byte 0: high nibble = sample high bits, low nibble = period high bits
# Byte 1: period low byte
# Byte 2: high nibble = sample low bits, low nibble = effect command
# Byte 3: effect argument
#
spec "Cell: silence" do
  before do
    @cell = Cell.new([0x00, 0x00, 0x00, 0x00])
  end

  it "sample_number is 0" do
    expect(@cell.sample_number).to eq(0)
  end

  it "note_period is 0" do
    expect(@cell.note_period).to eq(0)
  end

  it "effect_command is 0" do
    expect(@cell.effect_command).to eq(0)
  end

  it "effect_argument is 0" do
    expect(@cell.effect_argument).to eq(0)
  end
end

spec "Cell: sample number" do
  it "basic case 0x12 = 18" do
    cell = Cell.new([0x10, 0x00, 0x20, 0x00])
    expect(cell.sample_number).to eq(18)
  end

  it "maximum 0xFF = 255" do
    cell = Cell.new([0xF0, 0x00, 0xF0, 0x00])
    expect(cell.sample_number).to eq(255)
  end

  it "mixed bits 0xA5 = 165" do
    cell = Cell.new([0xA0, 0x00, 0x50, 0x00])
    expect(cell.sample_number).to eq(165)
  end
end

spec "Cell: note period" do
  it "parses 12-bit period from bytes 0-1" do
    # byte0 low nibble (0x0) << 8 | byte1 (0x38) = 0x038 = 56
    cell = Cell.new([0x10, 0x38, 0x00, 0x00])
    expect(cell.note_period).to eq(56)
  end

  it "parses C-3 period 214 = 0x0D6" do
    # byte0 low = 0x0, byte1 = 0xD6
    cell = Cell.new([0x00, 0xD6, 0x00, 0x00])
    expect(cell.note_period).to eq(214)
  end

  it "parses C-1 period 856 = 0x358" do
    # byte0 low = 0x3, byte1 = 0x58
    cell = Cell.new([0x03, 0x58, 0x00, 0x00])
    expect(cell.note_period).to eq(856)
  end
end

spec "Cell: effects" do
  it "parses effect command from byte 3 high nibble" do
    # byte3 = 0x23 → command = 2, argument = 3
    cell = Cell.new([0x00, 0x00, 0x00, 0x23])
    expect(cell.effect_command).to eq(2)
  end

  it "parses effect argument from byte 3 low nibble" do
    cell = Cell.new([0x00, 0x00, 0x00, 0x23])
    expect(cell.effect_argument).to eq(3)
  end

  it "parses volume slide effect 0xA5" do
    cell = Cell.new([0x00, 0x00, 0x00, 0xA5])
    expect(cell.effect_command).to eq(0xA)
    expect(cell.effect_argument).to eq(5)
  end
end
