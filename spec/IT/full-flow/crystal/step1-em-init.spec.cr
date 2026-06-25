include CrystalFlow;

describe "crystal step 1 - em init" do
  it "initializes a new crystal project" do
    FileUtils.rm_rf CrystalFlow::SANDBOX;
    FileUtils.mkdir_p CrystalFlow::SANDBOX;

    output = crystal_em_sandbox "--template crystal init __testing__";
    output.should contain("Creating directory: __testing__");
    File.exists?(File.join(CrystalFlow::PROJECT, "shard.yml")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "em.json")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "__testing__.cr")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "src", "__testing__.libs.cr")).should be_true;
    File.exists?(File.join(CrystalFlow::PROJECT, "spec", "__testing__.spec.cr")).should be_true;
    File.read(File.join(CrystalFlow::PROJECT, "em.json")).should contain("\"crystal\"");
  end

  it "rejects an empty project name" do
    crystal_em_raw(["init", ""], CrystalFlow::SANDBOX).should contain("Invalid name");
    Dir.children(CrystalFlow::SANDBOX).should eq(["__testing__"]);
  end
end
