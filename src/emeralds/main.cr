# Defines the main functionality when running the system
module Emeralds::Main
  def self.run
    Emeralds::Help.new.run if ARGV.size < 1;

    action = ARGV[0]
    case action
    when "init"
      Emeralds::Init.new.run;
    when "list"
      Emeralds::List.new.run;
    when "install"
      if ARGV.size < 2
        Emeralds::Install.new.run;
      elsif ARGV[1] == "dev"
        Emeralds::InstallDev.new.run;
      else
        Emeralds::Help.new.run;
      end
    when "build"
      Emeralds::Help.new.run if ARGV.size < 3;

      if ARGV[1] == "app"
        if ARGV[2] == "debug"
          Emeralds::BuildAppDebug.new.run;
        elsif ARGV[2] == "release"
          Emeralds::BuildAppRelease.new.run;
        else
          Emeralds::Help.new.run;
        end
      elsif ARGV[1] == "lib"
        if ARGV[2] == "debug"
          Emeralds::BuildLibDebug.new.run;
        elsif ARGV[2] == "release"
          Emeralds::BuildLibRelease.new.run;
        else
          Emeralds::Help.new.run;
        end
      else
        Emeralds::Help.new.run;
      end
    when "test"
      Emeralds::Test.new.run;
    when "version"
      Emeralds::Version.new.run;
    when "clean"
      Emeralds::Clean.new.run;
      # TODO Not working for now
      # when "makefile"
      #   Emeralds::GenerateMakefile.new.run;
    when "loc"
      if ARGV.size < 2
        Emeralds::Loc.new.run;
      elsif ARGV[1] == "deps"
        Emeralds::LocDeps.new.run;
      else
        Emeralds::Help.new.run;
      end
    when "help"
      Emeralds::Help.new.run;
    else
      Emeralds::Help.new.run;
    end
  end
end
