require "../../spec_helper";

describe "constants/cli" do
  it "defines CLI glyphs" do
    Emeralds::ARROW.should eq "➔";
    Emeralds::COG.should contain "⚙";
  end
end
