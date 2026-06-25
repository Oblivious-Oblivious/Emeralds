include CrystalFlow;

describe "crystal step 4 - em add / em remove" do
  it "adds module one" do
    crystal_em("add one").should contain("one.cr");
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "one", "one.cr")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "spec", "one", "one.spec.cr")).should be_true;
  end

  it "adds modules two and three" do
    crystal_em("add two").should contain("two.cr");
    crystal_em("add three").should contain("three.cr");
  end

  it "removes module one" do
    crystal_em("remove one").should contain("one.cr");
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "one", "one.cr")).should be_false;
    File.exists?(File.join(CrystalFlow::PROJECT, "spec", "one", "one.spec.cr")).should be_false;
  end

  it "removes modules two and three" do
    crystal_em("remove two").should contain("two.cr");
    crystal_em("remove three").should contain("three.cr");
  end

  it "adds nested module files" do
    output = crystal_em("add module/subfolder/test");

    output.should contain("module/subfolder/test.cr");
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "module", "subfolder", "test.cr")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "spec", "module", "subfolder", "test.spec.cr")).should be_true;
    libs = File.read(File.join(CrystalFlow::PROJECT, "src", "__testing__.libs.cr"));
    libs.should contain("require \"./module/subfolder/test\";");
    spec_main = File.read(File.join(CrystalFlow::PROJECT, "spec", "__testing__.spec.cr"));
    spec_main.should contain("require \"./module/subfolder/test.spec\";");
  end

  it "removes nested module files" do
    crystal_em("remove module/subfolder/test").should contain("module/subfolder/test.cr");

    File.exists?(File.join(CrystalFlow::PROJECT, "src", "module", "subfolder", "test.cr")).should be_false;
    File.exists?(File.join(CrystalFlow::PROJECT, "spec", "module", "subfolder", "test.spec.cr")).should be_false;
    libs = File.read(File.join(CrystalFlow::PROJECT, "src", "__testing__.libs.cr"));
    libs.should_not contain("require \"./module/subfolder/test\";");
  end

  it "refuses to add or remove the top-level project source" do
    crystal_em("add __testing__").should_not contain("reserved");
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "__testing__", "__testing__.cr")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "__testing__.cr")).should be_true;

    crystal_em("remove __testing__").should_not contain("reserved");
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "__testing__", "__testing__.cr")).should be_false;
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "__testing__.cr")).should be_true;
  end

  it "rejects an empty module name" do
    crystal_em_raw(["add", ""]).should contain("Invalid name");
    crystal_em_raw(["remove", ""]).should contain("Invalid name");
  end
end
