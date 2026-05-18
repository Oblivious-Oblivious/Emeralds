require "../../spec_helper";

describe Emeralds::InstallDev do
  it "creates libs when installing development dependencies" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "install", "dev";

      Dir.exists?("libs").should be_true;
    end
  end
end
