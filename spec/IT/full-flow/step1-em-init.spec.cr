require "../../spec_helper";

describe "step 1 - em init" do
  it "initializes a new project" do
    FileUtils.rm_rf SANDBOX;
    FileUtils.mkdir_p SANDBOX;

    em_sandbox("init __testing__").should contain("Creating directory: __testing__");
  end
end
