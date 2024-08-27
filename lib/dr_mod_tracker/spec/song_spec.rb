spec "BinaryFile" do |args, assert|
  before do |args, assert|
    # file_path = "/mygame/sounds/alex_menchi_-_xenon_3_miniblast.mod"
    file_path = "sounds/alex_menchi_-_xenon_3_miniblast.mod"

    @mod = DrMod.new file_path
    @mod.load_all
    @song = @mod.song
  end

  context '#read_sond_data' do
    # NOTE: an amiga word is 2 octets
    it 'load data song' do
      # TODO what are the invisible chars ?
      expect(@song.name.strip).to eq "xenon3miniblast"
      expect(@song.length).to eq 29 # TODO rename block_length ?
      expect(@song.tracker_byte).to eq 0 # TODO what is this ??
      expect(@song.format_signature).to eq "M.K."
    end
  end

end
