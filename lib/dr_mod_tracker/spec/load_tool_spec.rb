# LoadTool specs
#
# Tests for Amiga word decoding (big-endian, two's complement)
#
spec "LoadTool: decode_amiga_word" do
  before do
    @tool = Object.new
    @tool.extend LoadTool
  end

  it "decodes big-endian word 0x0100 = 256" do
    data = [0x01, 0x00].pack("C*")
    expect(@tool.decode_amiga_word(data, 0)).to eq(256)
  end

  it "decodes zero" do
    data = [0x00, 0x00].pack("C*")
    expect(@tool.decode_amiga_word(data, 0)).to eq(0)
  end

  it "decodes max positive 0x7FFF = 32767" do
    data = [0x7F, 0xFF].pack("C*")
    expect(@tool.decode_amiga_word(data, 0)).to eq(32767)
  end

  it "decodes negative 0xFFFF = -1" do
    data = [0xFF, 0xFF].pack("C*")
    expect(@tool.decode_amiga_word(data, 0)).to eq(-1)
  end

  it "decodes at non-zero offset" do
    data = [0x00, 0x00, 0x02, 0x10].pack("C*")
    expect(@tool.decode_amiga_word(data, 2)).to eq(528)
  end
end
