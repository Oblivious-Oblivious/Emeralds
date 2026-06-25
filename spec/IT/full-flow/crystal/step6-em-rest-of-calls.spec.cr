include CrystalFlow;

describe "crystal step 6 - em list / loc / lint / version / license" do
  it "lists dependencies and modules" do
    output = crystal_em("list");
    output.should contain("Dependencies:");
    output.should contain("Modules:");
    output.should contain("get-value");
  end

  it "counts the lines of code" do
    crystal_em("loc").should contain("SUM:");
  end

  it "lints the sources" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    output = crystal_em("lint");
    if File.exists? File.join(CrystalFlow::PROJECT, "bin", "ameba")
      output.should contain("src/get-value/get-value.cr");
    else
      output.should contain("ameba not found");
    end
  end

  it "prints the version" do
    crystal_em("version").should contain("__testing__ v0.0.1");
  end

  it "downloads the license" do
    crystal_em("license").should contain("LICENSE");
    File.read(File.join(CrystalFlow::PROJECT, "LICENSE")).should contain("MIT License");
  end
end
