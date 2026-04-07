# PatternPlayer navigation specs (#65)
#
# Tests for clamp_pattern, wrap_line, position bounds.
# Uses PatternPlayer.allocate to bypass initialize.
#
spec "clamp_pattern: bounds" do
  before do
    @player = PatternPlayer.allocate
    # Mock @mod.song.length via simple stubs
    song_stub = Object.new
    def song_stub.length; 29; end
    mod_stub = Object.new
    mod_stub.instance_variable_set(:@song, song_stub)
    def mod_stub.song; @song; end
    @player.instance_variable_set(:@mod, mod_stub)
  end

  it "stays unchanged when in range" do
    @player.instance_variable_set(:@current_pattern, 5)
    @player.send(:clamp_pattern)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(5)
  end

  it "wraps from above max to 0" do
    @player.instance_variable_set(:@current_pattern, 30)
    @player.send(:clamp_pattern)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(0)
  end

  it "wraps from negative to max" do
    @player.instance_variable_set(:@current_pattern, -1)
    @player.send(:clamp_pattern)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(28)
  end

  it "max is song.length - 1" do
    @player.instance_variable_set(:@current_pattern, 28)
    @player.send(:clamp_pattern)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(28)
  end
end

spec "wrap_line: line bounds" do
  before do
    @player = PatternPlayer.allocate
    @player.instance_variable_set(:@loop_pattern, false)
  end

  it "wraps from -1 to 63 and decrements pattern" do
    @player.instance_variable_set(:@current_line, -1)
    @player.instance_variable_set(:@current_pattern, 5)
    @player.send(:wrap_line)
    expect(@player.instance_variable_get(:@current_line)).to eq(63)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(4)
  end

  it "wraps from 64 to 0 and increments pattern" do
    @player.instance_variable_set(:@current_line, 64)
    @player.instance_variable_set(:@current_pattern, 5)
    @player.send(:wrap_line)
    expect(@player.instance_variable_get(:@current_line)).to eq(0)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(6)
  end

  it "loop mode: stays on same pattern when wrapping down" do
    @player.instance_variable_set(:@loop_pattern, true)
    @player.instance_variable_set(:@current_line, 64)
    @player.instance_variable_set(:@current_pattern, 5)
    @player.send(:wrap_line)
    expect(@player.instance_variable_get(:@current_pattern)).to eq(5)
  end
end
