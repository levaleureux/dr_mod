spec :another_spec do

  context "the_first_context" do
    before do
      @a = 4
    end

    it "expectation_3" do |args, assert|
      puts "I'm the num 3"
      puts @a = @a * 3
      expect(@a)
        .to(eq 12, fail_with: "nope 12")
        .and
        .to(eq 24 / 2, fail_with: "nope it's 12 again")
    end
  end
  context "I_got_a_mod_file" do
    before do
      @file = "the/path"
      puts @file.blue
    end
    it "read_the_mod" do
      puts "I'm the num 5"
    end
  end
end
