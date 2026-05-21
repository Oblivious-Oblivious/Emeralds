require "../../spec_helper";

describe "constants/languages" do
  it "maps common extensions to linguist labels" do
    Emeralds::EXTENSIONS[".c"].should eq "C";
    Emeralds::EXTENSIONS[".h"].should eq "C Header";
  end
end
