require "../../spec_helper";

describe Emeralds::BuildAppDebug do
  it "builds the app executable from a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "build", "app", "debug";

      File.exists?(File.join("export", "spec")).should be_true;
    end
  end
end
