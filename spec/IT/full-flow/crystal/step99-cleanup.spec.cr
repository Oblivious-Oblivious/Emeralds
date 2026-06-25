include CrystalFlow;

describe "crystal step 99 - cleanup" do
  it "removes the full flow files" do
    FileUtils.rm_rf CrystalFlow::SANDBOX;
    File.exists?(CrystalFlow::SANDBOX).should be_false;
  end
end
