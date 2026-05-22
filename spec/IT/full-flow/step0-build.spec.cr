require "../../spec_helper";

describe "step 0 - build" do
  it "builds the emeralds library" do
    Process.run("shards", ["build"], chdir: ROOT,
      output: Process::Redirect::Inherit, error: Process::Redirect::Inherit
    ).success?.should be_true;
  end
end
