include CrystalFlow;

describe "crystal step 7 - em install" do
  it "installs dependencies through shards" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    output = crystal_em("install");
    output.should contain("Resolving dependencies");
  end

  it "delegates `install all` to shards" do
    crystal_em("install all").should contain("handled through `shards`");
  end

  it "delegates `install <link>` to shards" do
    crystal_em("install https://github.com/crystal-ameba/ameba").should contain("handled through `shards`");
  end

  it "delegates `install dev` to shards" do
    crystal_em("install dev").should contain("handled through `shards`");
  end

  it "rejects an empty or blank install argument" do
    crystal_em_raw(["install", ""]).should contain("Invalid name");
    crystal_em_raw(["install", "   "]).should contain("Invalid name");
  end
end
