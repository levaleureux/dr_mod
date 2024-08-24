spec "BinaryFile" do |args, assert|
  before do |args, assert|
   @file_path = File.expand_path 'lib/dr_mod_tracker/spec/fixture/file.bin'
   end
  context '#read_word' do
    # NOTE: an amiga word is 2 octets
    it 'reads an amiga word from the binary file' do
      puts @file_path.green

      word =  'AB'
      #File.binwrite @file_path, word
      $gtk.write_file @file_path, word

      # TODO note a let will be usefull here
      file = BinaryFile.new @file_path
      expect(file.read_word).to eq 16961 # 'AB' en décimal
      expect(file.read_word).to eq word.unpack('S<')[0]
    end
  end

  context '#read_octet' do
    it 'reads an octet from the binary file' do
      octet = 'A'
      #File.binwrite @file_path, octet
      $gtk.write_file @file_path, octet

      file = BinaryFile.new @file_path
      expect(file.read_octet).to eq 65
      expect(file.read_octet).to eq octet.ord
    end
  end
end
