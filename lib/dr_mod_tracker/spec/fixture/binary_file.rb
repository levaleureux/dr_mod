spec "BinaryFile" do |args, assert|
  context '#read_word' do
    it 'reads a word from the binary file' do

      word =  'AB'
      File.binwrite(file_path, word)

      file = BinaryFile.new(file_path)
      expect(file.read_word).to eq 16961 # 'AB' en décimal
      expect(file.read_word).to eq word
    end
  end

  context '#read_octet' do
    it 'reads an octet from the binary file' do
      octet = 'A'
      File.binwrite(file_path, octet)

      file = BinaryFile.new(file_path)
      expect(file.read_octet).to eq 65
      expect(file.read_octet).to eq octet
    end
  end
end

