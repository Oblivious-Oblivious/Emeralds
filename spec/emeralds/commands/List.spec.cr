require "../../spec_helper";

describe Emeralds::List do
  it "lists dependencies from a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "list";
    end
  end
end
