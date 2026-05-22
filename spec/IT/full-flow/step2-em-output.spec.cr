require "../../spec_helper";

describe "step 2 - em output" do
  it "prints the help/usage screen" do
    output = em("");
    output.should contain("Emeralds - Help/Usage");
    output.should contain("emeralds/em [<command>]");
  end

  it "prints the same help/usage screen with commands" do
    output = em("help");
    output.should contain("Emeralds - Help/Usage");
    output.should contain("build");
    output.should contain("test");
  end
end
