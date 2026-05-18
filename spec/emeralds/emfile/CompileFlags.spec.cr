require "../../spec_helper";

describe Emeralds::CompileFlags do
  it "stores compiler and debug/release build configs" do
    debug = Emeralds::BuildConfig.new(opt: "-Og");
    release = Emeralds::BuildConfig.new(opt: "-O2");
    flags = Emeralds::CompileFlags.new(
      cc: "clang",
      debug: debug,
      release: release
    );

    flags.cc.should eq "clang";
    flags.debug.should eq debug;
    flags.release.should eq release;
  end
end
