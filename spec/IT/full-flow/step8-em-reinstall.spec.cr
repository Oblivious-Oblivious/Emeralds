require "../../spec_helper";

describe "step 8 - em reinstall / em uninstall" do
  it "reinstalls the dependencies" do
    em("reinstall").should contain("Installing `cSpec`");
  end

  it "runs the tests after reinstalling" do
    em("test").should contain("1 passing");
  end

  it "rejects an empty or blank dependency name" do
    em_raw(["uninstall", ""]).should contain("Invalid name");
    em_raw(["uninstall", "   "]).should contain("Invalid name");
  end

  it "uninstalls cSpec" do
    em("uninstall cSpec").should contain("Removed `cSpec`");
  end

  it "removes the git dependency from em.json" do
    File.read(File.join(PROJECT, "em.json")).should_not contain("https://github.com/Oblivious-Oblivious/cSpec.git");
  end

  it "fails the tests after uninstalling cSpec" do
    em("test").should contain("not in the list of dependencies");
  end
end
