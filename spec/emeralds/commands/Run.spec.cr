require "../../spec_helper";

describe Emeralds::Run do
  it "runs the executable built from a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "build", "app", "debug";

      repo.run "run";
    end
  end
end
