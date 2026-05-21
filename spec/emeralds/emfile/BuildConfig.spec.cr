require "../../spec_helper";

describe Emeralds::BuildConfig do
  it "stores explicit compiler options" do
    config = Emeralds::BuildConfig.new(
      opt: "-O2",
      version: "-std=c89",
      flags: "-g",
      warnings: "-Wall",
      libs: "-lm"
    );

    config.opt.should eq "-O2";
    config.version.should eq "-std=c89";
    config.flags.should eq "-g";
    config.warnings.should eq "-Wall";
    config.libs.should eq "-lm";
  end
end
