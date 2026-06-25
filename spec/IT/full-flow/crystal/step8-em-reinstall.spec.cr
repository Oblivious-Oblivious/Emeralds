include CrystalFlow;

describe "crystal step 8 - em reinstall / em uninstall" do
  it "reinstalls the dependencies" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    crystal_em("reinstall").should contain("Resolving dependencies");
  end

  it "delegates uninstall to shards" do
    crystal_em("uninstall ameba").should contain("handled through `shards`");
  end

  it "rejects an empty or blank dependency name" do
    crystal_em_raw(["uninstall", ""]).should contain("Invalid name");
    crystal_em_raw(["uninstall", "   "]).should contain("Invalid name");
  end
end
