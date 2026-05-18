require "../../spec_helper";

describe Emeralds::Help do
  it "uses the expected help message" do
    Emeralds::Help.new.message.should eq "Emeralds - Help/Usage";
  end
end
