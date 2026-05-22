require "../../spec_helper";

describe "step 7 - em reinstall / em uninstall" do
  it "reinstalls the dependencies" do
    em("reinstall").should contain("Installing `cSpec`");
  end

  it "runs the tests after reinstalling" do
    em("test").should contain("1 passing");
  end

  it "uninstalls cSpec" do
    em("uninstall cSpec").should contain("Removed `cSpec`");
  end

  it "fails the tests after uninstalling cSpec" do
    em("test").should contain("not in the list of dependencies");
  end
end
