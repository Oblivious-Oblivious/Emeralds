include CrystalFlow;

describe "crystal step 5 - em build / em run / em clean" do
  it "builds the app for release" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    crystal_em("build app release").should contain("shards build");
    File.exists?(File.join(CrystalFlow::PROJECT, "bin", "__testing__")).should be_true;
  end

  it "runs the compiled app" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    crystal_em("run").should contain("Hello, World!");
  end

  it "cleans the build artifacts" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    crystal_em("clean").should contain("bin/__testing__");
    File.exists?(File.join(CrystalFlow::PROJECT, "bin", "__testing__")).should be_false;
  end

  it "warns when running after cleaning" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    crystal_em("run").should contain("not found, build the project first");
  end
end
