# Tempo conversion specs
#
# Tests the Amiga tick → DragonRuby frame conversion.
# Formula: frames = (60 * speed * 2.5) / bpm
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
