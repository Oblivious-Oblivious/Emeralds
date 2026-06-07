describe Emeralds::Terminal do
  describe ".repo_name" do
    it "derives the name from a plain link" do
      Emeralds::Terminal.repo_name("https://github.com/Oblivious-Oblivious/cSpec").should eq("cSpec");
    end

    it "ignores a trailing slash" do
      Emeralds::Terminal.repo_name("https://github.com/Oblivious-Oblivious/cSpec").should eq("cSpec");
    end

    it "strips a .git suffix" do
      Emeralds::Terminal.repo_name("https://github.com/Oblivious-Oblivious/cSpec").should eq("cSpec");
    end

    it "strips a .git suffix before a trailing slash" do
      Emeralds::Terminal.repo_name("https://github.com/Oblivious-Oblivious/cSpec").should eq("cSpec");
    end

    it "derives the name from an ssh link" do
      Emeralds::Terminal.repo_name("git@github.com:Oblivious-Oblivious/cSpec").should eq("cSpec");
    end
  end
end
