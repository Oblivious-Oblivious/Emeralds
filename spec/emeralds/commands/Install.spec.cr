require "../../spec_helper";

describe Emeralds::Install do
  it "creates libs and installs production dependencies" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "install";

      Dir.exists?("libs").should be_true;
    end
  end
end
