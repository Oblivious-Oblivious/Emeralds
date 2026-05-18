require "../../spec_helper";

describe Emeralds::Command do
  it "validates portable filenames" do
    command = Emeralds::Add.new;

    command.validate_filename("valid_name").should be_true;
    command.validate_filename("foo-bar").should be_true;
    command.validate_filename("").should be_false;
    command.validate_filename("   ").should be_false;
    command.validate_filename(".").should be_false;
    command.validate_filename("..").should be_false;
    command.validate_filename("../bad").should be_false;
    command.validate_filename("bad:name").should be_false;
    command.validate_filename("aux").should be_false;
    command.validate_filename("con").should be_false;
    command.validate_filename("LPT1").should be_false;
  end
end

describe "command messages" do
  it "defines a message for every command class" do
    commands = [
      Emeralds::Add.new,
      Emeralds::BuildAppDebug.new,
      Emeralds::BuildAppRelease.new,
      Emeralds::BuildLibDebug.new,
      Emeralds::BuildLibRelease.new,
      Emeralds::Clean.new,
      Emeralds::GenerateMakefile.new,
      Emeralds::Help.new,
      Emeralds::Init.new,
      Emeralds::Install.new,
      Emeralds::InstallAll.new,
      Emeralds::InstallDev.new,
      Emeralds::License.new,
      Emeralds::List.new,
      Emeralds::Loc.new,
      Emeralds::Reinstall.new,
      Emeralds::Run.new,
      Emeralds::Test.new,
      Emeralds::Version.new,
    ];

    commands.each do |command|
      command.message.should contain "Emeralds - ";
    end
  end
end

