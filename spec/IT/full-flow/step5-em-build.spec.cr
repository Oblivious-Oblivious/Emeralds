require "../../spec_helper";

describe "step 5 - em build / em run / em clean" do
  it "builds the app for release" do
    em("build app release").should contain("export/__testing__");
  end

  it "runs the compiled app" do
    em("run").should contain("Hello, World!");
  end

  it "cleans the build artifacts" do
    em("clean").should contain("remove export");
  end

  it "fails to run after cleaning" do
    em("run").should contain("No such file or directory");
  end
end
