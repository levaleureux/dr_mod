# Sample specs
#
# Tests for sample normalization and finetune parsing
#
spec "Sample: normalize_value" do
  before do
    # Create a minimal sample to test normalize_value
    # Sample needs mod_data — use a dummy with valid header
    @dummy_data = ([0] * 1200).pack("C*")
    @sample = Sample.new 0, @dummy_data
  end

  it "maps 0 to 0.0 (silence positive)" do
    expect(@sample.normalize_value(0)).to eq(0.0)
  end

  it "maps 127 to ~0.99 (max positive)" do
    result = @sample.normalize_value(127)
    expect(result).to be_greater_than(0.99)
  end

  it "maps 128 to -1.0 (max negative)" do
    expect(@sample.normalize_value(128)).to eq(-1.0)
  end

  it "maps 255 to ~-0.008 (near zero negative)" do
    result = @sample.normalize_value(255)
    expect(result).to be_greater_than(-0.01)
  end
end

spec "Sample: SAMPLE_COUNT" do
  it "is 31 (ProTracker spec)" do
    expect(SamplesLoader::SAMPLE_COUNT).to eq(31)
  end
end
