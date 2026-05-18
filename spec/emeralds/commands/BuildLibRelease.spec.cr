require "../../spec_helper";

describe Emeralds::BuildLibRelease do
  it "builds the release library export from a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "build", "lib", "release";

      File.exists?(File.join("export", "spec.a")).should be_true;
      File.exists?(File.join("export", "spec.a.test")).should be_true;
      File.exists?(File.join("export", "get_value", "get_value.h")).should be_true;
      File.exists?(File.join("export", "get_value", "get_value.c")).should be_false;
    end
  end
end
