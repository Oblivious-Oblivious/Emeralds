require "../../spec_helper";

describe Emeralds::License do
  it "downloads a license in a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "license";

      File.exists?("LICENSE").should be_true;
    end
  end
end
