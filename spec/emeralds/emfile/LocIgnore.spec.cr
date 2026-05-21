require "../../spec_helper";

describe Emeralds::LocIgnore do
  it "stores ignored extensions and directories" do
    ignore = Emeralds::LocIgnore.new(
      extensions: [".c", ".h"],
      directories: ["libs"]
    );

    ignore.extensions.should eq [".c", ".h"];
    ignore.directories.should eq ["libs"];
  end

  it "defaults constructor values to nil" do
    ignore = Emeralds::LocIgnore.new;

    ignore.extensions.should be_nil;
    ignore.directories.should be_nil;
  end

  it "defaults missing json fields to empty arrays" do
    ignore = Emeralds::LocIgnore.from_json %({});

    ignore.extensions.should eq [] of String;
    ignore.directories.should eq [] of String;
  end
end
