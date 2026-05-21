require "../../spec_helper";

describe Emeralds::Test do
  it "runs the test command in a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "test";
    end
  end

  it "installs cSpec and runs tests" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "install", "dev";
      repo.run "test";
    end
  end
end
