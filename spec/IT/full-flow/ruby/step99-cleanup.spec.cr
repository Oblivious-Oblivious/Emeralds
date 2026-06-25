include RubyFlow;

describe "ruby step 99 - cleanup" do
  it "removes the full flow files" do
    FileUtils.rm_rf RubyFlow::SANDBOX;
    File.exists?(RubyFlow::SANDBOX).should be_false;
  end
end
