require "../../spec_helper";

describe Emeralds::Reinstall do
  it "reinstalls dependencies into libs" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "reinstall";

      Dir.exists?("libs").should be_true;
    end
  end
end
