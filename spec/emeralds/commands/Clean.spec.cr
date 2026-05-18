require "../../spec_helper";

describe Emeralds::Clean do
  it "removes generated build output" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "build", "app", "debug";

      repo.run "clean";

      Dir.exists?("export").should be_false;
    end
  end
end
