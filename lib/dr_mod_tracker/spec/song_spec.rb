# Song specs — requires loading the actual MOD file
#
# Uses sounds/alex_menchi_-_xenon_3_miniblast.mod as reference.
# Values verified against XMP output.
#
spec "Song: header parsing" do
  before do
    file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"
    @mod = DrMod.new file_path
    @mod.load_all
    @song = @mod.song
  end

  it "parses song name" do
    expect(@song.name.strip).to eq "xenon3miniblast"
  end

  it "parses song length (29 positions)" do
    expect(@song.length).to eq 29
  end

  it "parses format signature M.K." do
    expect(@song.format_signature).to eq "M.K."
  end
end

spec "Song: pattern_count" do
  before do
    file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"
    @mod = DrMod.new file_path
    @mod.load_all
    @song = @mod.song
  end

  # XMP reports 18 patterns for this file
  it "returns max position + 1" do
    expect(@song.pattern_count).to eq 18
  end

  it "pattern_size is 1024 bytes" do
    expect(@song.pattern_size).to eq 1024
  end
end

spec "Song: samples_start_at" do
  before do
    file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"
    @mod = DrMod.new file_path
    @mod.load_all
    @song = @mod.song
  end

  # 1084 (header) + 18 patterns * 1024 bytes
  it "calculates correct offset" do
    expected = 1084 + (18 * 1024)
    expect(@song.samples_start_at).to eq expected
  end
end

spec "Samples: loaded from MOD" do
  before do
    file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"
    @mod = DrMod.new file_path
    @mod.load_all
  end

  it "loads 31 samples" do
    expect(@mod.samples.length).to eq 31
  end

  # Values verified against XMP dump
  it "first sample is Kick with volume 64" do
    kick = @mod.samples[0]
    expect(kick.name.strip).to eq "Kick"
    expect(kick.volume).to eq 64
    expect(kick.finetune).to eq 0
  end

  it "bass sample has finetune +1" do
    bass = @mod.samples[4]
    expect(bass.name.strip).to eq "bass"
    expect(bass.finetune).to eq 1
  end

  it "guit sample has volume 50" do
    guit = @mod.samples[6]
    expect(guit.name.strip).to eq "guit"
    expect(guit.volume).to eq 50
  end

  # Length is in bytes (words * 2)
  it "sample length is in bytes not words" do
    kick = @mod.samples[0]
    expect(kick.length).to be_greater_than(2000)
  end
end
