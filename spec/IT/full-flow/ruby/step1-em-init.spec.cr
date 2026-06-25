include RubyFlow;

describe "ruby step 1 - em init" do
  it "initializes a new ruby project" do
    FileUtils.rm_rf RubyFlow::SANDBOX;
    FileUtils.mkdir_p RubyFlow::SANDBOX;

    output = ruby_em_sandbox "--template ruby init __testing__";
    output.should contain("Creating directory: __testing__");
    File.exists?(File.join(RubyFlow::PROJECT, "Gemfile")).should be_true;
    File.exists?(File.join(RubyFlow::PROJECT, "em.json")).should be_true;
    File.exists?(File.join(RubyFlow::PROJECT, "src", "__testing__.rb")).should be_true;
    File.exists?(File.join(RubyFlow::PROJECT, "spec", "spec_helper.rb")).should be_true;
    File.read(File.join(RubyFlow::PROJECT, "em.json")).should contain("\"ruby\"");
    File.read(File.join(RubyFlow::PROJECT, "Gemfile")).should contain("rspec");
  end

  it "rejects an empty project name" do
    ruby_em_raw(["init", ""], RubyFlow::SANDBOX).should contain("Invalid name");
    Dir.children(RubyFlow::SANDBOX).should eq(["__testing__"]);
  end
end
