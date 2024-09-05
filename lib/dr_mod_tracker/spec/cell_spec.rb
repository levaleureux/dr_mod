spec "Cell" do
  context "Note de base (La standard)" do
    before do
      # La note de base (A4) avec une période typique, sans effets
      @cell_data = [0x10, 0x38, 0x00, 0x00]
      @cell = Cell.new @cell_data
    end

    it "parses the sample number correctly" do
      puts "TODO tester les bin reader".blue
      puts @cell.sample_number.to_s.blue
      # expect(@cell.sample_number).to eq(16)
    end

    xit "parses the note period correctly" do
      expect(@cell.note_period).to eq(824)
    end

    xit "parses the effect command as 0 (no effect)" do
      expect(@cell.effect_command).to eq(0)
    end

    xit "parses the effect argument as 0 (no argument)" do
      expect(@cell.effect_argument).to eq(0)
    end
  end

  context "Note avec effet d'arpège" do
    # context "Note avec effet d'arpège" do
    before do
      # Une note (A4) avec un effet d'arpège
      @cell_data = [0x12, 0x34, 0x01, 0x23]
      @cell = Cell.new @cell_data
    end

    xit "parses the sample number correctly" do
      expect(@cell.sample_number).to eq(18)
    end

    xit "parses the note period correctly" do
      expect(@cell.note_period).to eq(564)
    end

    xit "parses the effect command correctly (arpège)" do
      expect(@cell.effect_command).to eq(2)
    end

    xit "parses the effect argument correctly" do
      expect(@cell.effect_argument).to eq(3)
    end
  end

  context "Note de silence (aucune note jouée, aucun effet)" do
    before do
      # Une cellule silencieuse sans note ni effet
      @cell_data = [0x00, 0x00, 0x00, 0x00]
      @cell = Cell.new @cell_data
    end

    it "sets sample_number to 0" do
      expect(@cell.sample_number).to eq(0)
    end

    it "sets note_period to 0" do
      expect(@cell.note_period).to eq(0)
    end

    it "sets effect_command to 0" do
      expect(@cell.effect_command).to eq(0)
    end

    it "sets effect_argument to 0" do
      expect(@cell.effect_argument).to eq(0)
    end
  end
end

# sample number
#
spec 'when reading sample number' do

  it 'returns correct sample number for basic case' do
    @cell = Cell.new [0x10, 0x00, 0x20, 0x00]  # 0x1 | 0x2 = 0x12 = 18
    expect(@cell.sample_number).to eq(18)
  end

  it 'returns maximum possible sample number' do
    @cell = Cell.new [0xF0, 0x00, 0xF0, 0x00]  # 0xF | 0xF = 0xFF = 255
    expect(@cell.sample_number).to eq(255)
  end
  it 'returns correct sample number for mixed bits' do
    @cell = Cell.new([0xA0, 0x00, 0x50, 0x00])  # 0xA | 0x5 = 0xA5 = 165
    expect(@cell.sample_number).to eq(165)
  end

  it 'returns zero when all bits are low' do
    @cell = Cell.new([0x00, 0x00, 0x00, 0x00])  # 0x0 | 0x0 = 0x00 = 0
    expect(@cell.sample_number).to eq(0)
  end
end

# note period
#
spec 'when reading note period' do

  xit 'returns maximum possible note period' do
    @cell = Cell.new([0x0F, 0xFF, 0x00, 0x00])  # (0xF << 8) | 0xFF = 0xFFF = 4095
    expect(@cell.note_period).to eq(4095)
  end

  it 'returns zero when all bits are zero' do
    @cell = Cell.new([0x00, 0x00, 0x00, 0x00])  # (0x0 << 8) | 0x00 = 0x000 = 0
    expect(@cell.note_period).to eq(0)
  end

  # TODO how to test it ??
  #
  it 'print a note periode' do
    @cell.print_note_period 570
  end
end

spec 'when reading note names from periods in an octave (C-1 to C-2)' do
  it 'returns "C-1" for period 570' do
    @cell = Cell.new([0x00, 0x02, 0x3A, 0x00])
    puts "-------------------------".blue
    puts @cell.note_en.to_s.red
    @cell.print_note_period 570
    puts "-------------------------".blue
    expect(@cell.note_en).to eq("G-1")
  end

  it 'returns "G-1" for period 570' do
    @cell = Cell.new([0x00, 0x02, 0x3A, 0x00])
    expect(@cell.note_en).to eq("G-1")
  end

  it 'returns "B-1" for period 453' do
    @cell = Cell.new([0x00, 0x01, 0xC5, 0x00])
    expect(@cell.note_en).to eq("B-1")
  end

  it 'returns "C-2" for period 428' do
    @cell = Cell.new([0x00, 0x01, 0xac, 0x00])
    expect(@cell.note_en).to eq("C-2")
  end

  #
  #
  it 'returns correct bytes for a given note period' do
    params         = [ 0x00, 0x03, 0x58, 0x00] # Période 856 (C-2)
    cell           = Cell.new params
    note_period    = 856 # Correspond à C-1
    expected_bytes = [0x03, 0x58]
    # puts cell.bytes_to_note_periode(params)
    expect(cell.note_period_to_bytes(note_period)).to eq(expected_bytes)
  end

  xit 'returns a 4-byte array with correct data for a given note period' do
    cell = Cell.new([0x03, 0x58, 0x00, 0x00])  # Période 856 (C-2)
    note_period = 856 # Correspond à C-1
    expected_cell_data = [3, 0x80, 0x00, 0x00]
    expect(cell.construct_cell_data_for_note_periode(note_period)).to eq(expected_cell_data)
  end
end
