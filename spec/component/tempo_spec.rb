# Tempo and navigation effects specs
#
# Tests: Amiga tick → DR frame conversion,
#        position jump (0xB), pattern break (0xD)
#
spec "Tempo: compute_frames_per_line" do
  before do
    @player = PatternPlayer.allocate
  end

  it "default speed=6 bpm=125 gives 7 frames" do
    @player.instance_variable_set(:@speed, 6)
    @player.instance_variable_set(:@bpm, 125)
    result = @player.send(:compute_frames_per_line)
    expect(result).to eq(7)
  end

  it "fast speed=3 bpm=125 gives 4 frames" do
    @player.instance_variable_set(:@speed, 3)
    @player.instance_variable_set(:@bpm, 125)
    result = @player.send(:compute_frames_per_line)
    expect(result).to eq(4)
  end

  it "slow speed=12 bpm=125 gives 14 frames" do
    @player.instance_variable_set(:@speed, 12)
    @player.instance_variable_set(:@bpm, 125)
    result = @player.send(:compute_frames_per_line)
    expect(result).to eq(14)
  end

  it "high bpm=150 speed=6 gives 6 frames" do
    @player.instance_variable_set(:@speed, 6)
    @player.instance_variable_set(:@bpm, 150)
    result = @player.send(:compute_frames_per_line)
    expect(result).to eq(6)
  end

  it "minimum speed=1 gives 1 frame" do
    @player.instance_variable_set(:@speed, 1)
    @player.instance_variable_set(:@bpm, 125)
    result = @player.send(:compute_frames_per_line)
    expect(result).to eq(1)
  end
end

spec "Navigation: position_jump (0xB)" do
  before do
    @player = PatternPlayer.allocate
    @player.instance_variable_set(:@current_pattern, 5)
    @player.instance_variable_set(:@current_line, 32)
  end

  it "jumps to specified position" do
    @player.send(:position_jump, 10)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(10)
  end

  # Line set to -1 because advance_if_playing adds 1 after
  it "resets line to -1 (becomes 0 after increment)" do
    @player.send(:position_jump, 10)
    expect(@player.instance_variable_get(:@current_line)).to eq(-1)
  end
end

spec "Navigation: pattern_break (0xD)" do
  before do
    @player = PatternPlayer.allocate
    @player.instance_variable_set(:@current_pattern, 5)
    @player.instance_variable_set(:@current_line, 32)
  end

  it "advances to next pattern" do
    @player.send(:pattern_break, 0x00)
    pattern = @player.instance_variable_get(:@current_pattern)
    expect(pattern).to eq(6)
  end

  # BCD: 0x16 = 1*10 + 6 = line 16
  it "breaks to BCD-encoded target line" do
    @player.send(:pattern_break, 0x16)
    line = @player.instance_variable_get(:@current_line)
    expect(line).to eq(15)
  end

  # Break to line 0: argument 0x00
  it "breaks to line 0 by default" do
    @player.send(:pattern_break, 0x00)
    line = @player.instance_variable_get(:@current_line)
    expect(line).to eq(-1)
  end
end
