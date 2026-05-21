require "../../spec_helper";

describe Emeralds::InstallAll do
  it "creates libs when installing all dependencies" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "install", "all";

      Dir.exists?("libs").should be_true;
    end
  end
end
