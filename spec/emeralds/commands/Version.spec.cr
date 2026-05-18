require "../../spec_helper";

describe Emeralds::Version do
  it "matches em.json from em init in a temporary repo" do
    EmeraldsSpec.with_repo do
      emfile = Emeralds::Emfile.from_json(File.read("em.json"));
      emfile.name.should eq "spec";
      emfile.version.should eq "0.1.0";
    end
  end
end
