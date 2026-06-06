describe "step 99 - cleanup" do
  it "removes the full flow files" do
    FileUtils.rm_rf SANDBOX;
    File.exists?(SANDBOX).should be_false;
  end
end
