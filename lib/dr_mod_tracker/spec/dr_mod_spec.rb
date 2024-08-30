spec :another_spec do

  context "the_first_context" do
    before do
      @a = 4
      puts "yo".red
    end

    it "expectation_3" do |args, assert|
      puts "I'm the num 3".blue
      puts @a = @a * 3
      expect(@a)
        .to(eq 12, fail_with: "nope 12")
        .and
        .to(eq 24 / 2, fail_with: "nope it's 12 again")
    end
  end
end
