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

  it "uninstalls cSpec from libs while it is installed" do
    em("uninstall cSpec").should contain("Removed `cSpec` from libs");
  end

  it "keeps the git dependency in em.json while it is still declared" do
    File.read(File.join(PROJECT, "em.json")).should contain("https://github.com/Oblivious-Oblivious/cSpec");
  end

  it "cannot run the tests with cSpec missing from libs" do
    em("test").should contain("cSpec is not installed");
  end

  it "removes the git dependency from em.json on a second uninstall" do
    em("uninstall cSpec").should contain("Removed `cSpec` from em.json");
    File.read(File.join(PROJECT, "em.json")).should_not contain("https://github.com/Oblivious-Oblivious/cSpec");
  end

  it "reports cSpec is not a dependency once fully removed" do
    em("test").should contain("not in the list of dependencies");
  end
end
