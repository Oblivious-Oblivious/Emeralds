require "../../spec_helper";

describe "constants/version" do
  it "keeps shard.yml and Emeralds::VERSION in sync" do
    shard_version = File.read("shard.yml").lines.find { |line|
      line.starts_with? "version:";
    }.not_nil!.split(':', 2)[1].strip;

    shard_version.should eq Emeralds::VERSION;
  end
end
