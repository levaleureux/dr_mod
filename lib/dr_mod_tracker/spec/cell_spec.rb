spec "Cell" do
  context "Note de base (La standard)" do
    before do
      # La note de base (A4) avec une période typique, sans effets
      @cell_data = [0x10, 0x38, 0x00, 0x00]
      @cell = Cell.new(@cell_data)
    end

    xit "parses the sample number correctly" do
      expect(@cell.sample_number).to eq(16)
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
    before do
      # Une note (A4) avec un effet d'arpège
      @cell_data = [0x12, 0x34, 0x01, 0x23]
      @cell = Cell.new(@cell_data)
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
      @cell = Cell.new(@cell_data)
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
