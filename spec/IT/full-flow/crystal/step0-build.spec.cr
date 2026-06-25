include CrystalFlow;

describe "crystal step 0 - build" do
  it "builds the emeralds library" do
    Process.run("shards", ["build", "emeralds"], chdir: ROOT,
      output: Process::Redirect::Inherit, error: Process::Redirect::Inherit
    ).success?.should be_true;
  end
end
