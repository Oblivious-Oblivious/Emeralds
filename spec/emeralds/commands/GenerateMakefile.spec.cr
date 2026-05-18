require "../../spec_helper";

describe Emeralds::GenerateMakefile do
  it "writes the current empty Makefile template" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "makefile";

      File.exists?("Makefile").should be_true;
      File.read("Makefile").should eq "";
    end
  end
end
