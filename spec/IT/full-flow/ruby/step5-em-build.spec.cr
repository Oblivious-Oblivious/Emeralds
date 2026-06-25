include RubyFlow;

describe "ruby step 5 - em build / em run / em clean" do
  it "reports ruby is interpreted and nothing to build" do
    ruby_em("build app release").should contain("Ruby is interpreted");
  end

  it "runs the application" do
    pending "ruby toolchain required" unless RubyFlow.tools?;
    ruby_em("run").should contain("Hello, World!");
  end

  it "cleans the yard/docs artifacts" do
    FileUtils.mkdir_p File.join(RubyFlow::PROJECT, ".yardoc");
    FileUtils.mkdir_p File.join(RubyFlow::PROJECT, "doc");
    output = ruby_em("clean");
    output.should contain("remove .yardoc");
    output.should contain("remove doc");
    File.exists?(File.join(RubyFlow::PROJECT, ".yardoc")).should be_false;
    File.exists?(File.join(RubyFlow::PROJECT, "doc")).should be_false;
  end
end
