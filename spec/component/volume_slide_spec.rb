# Volume Slide (0xA) specs — TDD
#
# Pragmatic version: applied once per line with speed multiplier.
# Param xy: x>0 slide up, y>0 slide down (one is 0).
# Total change per line = speed × step.
#
spec "Volume Slide: slide up" do
  before do
    @player = PatternPlayer.allocate
    @player.instance_variable_set(:@speed, 6)
  end

  # 0x20 = x=2, y=0 → slide up 2 per tick × 6 ticks = +12
  it "increases volume by speed * step" do
    @player.instance_variable_set(:@channel_volumes, [40, 40, 40, 40])
    @player.send(:volume_slide, 0, 0x20)
    vol = @player.instance_variable_get(:@channel_volumes)[0]
    expect(vol).to eq(52)
  end

  # 0x50 = x=5, y=0 → +30 but vol=40 → 70 → clamped to 64
  it "clamps at 64" do
    @player.instance_variable_set(:@channel_volumes, [40, 40, 40, 40])
    @player.send(:volume_slide, 0, 0x50)
    vol = @player.instance_variable_get(:@channel_volumes)[0]
    expect(vol).to eq(64)
  end
end

spec "Volume Slide: slide down" do
  before do
    @player = PatternPlayer.allocate
    @player.instance_variable_set(:@channel_volumes, [40, 40, 40, 40])
    @player.instance_variable_set(:@speed, 6)
  end

  # 0x03 = x=0, y=3 → slide down 3 per tick × 6 ticks = -18
  it "decreases volume by speed * step" do
    @player.send(:volume_slide, 0, 0x03)
    vol = @player.instance_variable_get(:@channel_volumes)[0]
    expect(vol).to eq(22)
  end

  # Clamp at 0 min
  it "clamps at 0" do
    @player.instance_variable_set(:@channel_volumes, [5, 40, 40, 40])
    @player.send(:volume_slide, 0, 0x03)
    vol = @player.instance_variable_get(:@channel_volumes)[0]
    expect(vol).to eq(0)
  end
end

spec "Volume Slide: no change" do
  before do
    @player = PatternPlayer.allocate
    @player.instance_variable_set(:@channel_volumes, [40, 40, 40, 40])
    @player.instance_variable_set(:@speed, 6)
  end

  # 0x00 = no slide
  it "does nothing with argument 0" do
    @player.send(:volume_slide, 0, 0x00)
    vol = @player.instance_variable_get(:@channel_volumes)[0]
    expect(vol).to eq(40)
  end
end
