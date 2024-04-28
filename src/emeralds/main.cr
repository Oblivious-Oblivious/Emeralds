# Defines the main functionality when running the system
module Emeralds::Main
  def self.run
    Help.new.run if ARGV.size < 1;

    action = ARGV[0]
    case action
    when "init"
      if ARGV.size == 1
        Help.new.run;
      else
        Init.new.run;
      end
    when "list"
      List.new.run;
    when "install"
      if ARGV.size < 2
        Install.new.run;
      elsif ARGV[1] == "dev"
        InstallDev.new.run;
      elsif ARGV[1] == "all"
        InstallAll.new.run;
      else
        Help.new.run;
      end
    when "build"
      Help.new.run if ARGV.size < 3;

      if ARGV[1] == "app"
        if ARGV[2] == "debug"
          BuildAppDebug.new.run;
        elsif ARGV[2] == "release"
          BuildAppRelease.new.run;
        else
          Help.new.run;
        end
      elsif ARGV[1] == "lib"
        if ARGV[2] == "debug"
          BuildLibDebug.new.run;
        elsif ARGV[2] == "release"
          BuildLibRelease.new.run;
        else
          Help.new.run;
        end
      else
        Help.new.run;
      end
    when "add"
      if ARGV.size == 1
        Help.new.run;
      else
        Add.new.run;
      end
    when "run"
      Run.new.run;
    when "test"
      Test.new.run;
    when "version"
      Version.new.run;
    when "clean"
      Clean.new.run;
    when "makefile"
      GenerateMakefile.new.run;
    when "loc"
      if ARGV.size < 2
        Loc.new.run;
      elsif ARGV[1] == "deps"
        LocDeps.new.run;
      else
        Help.new.run;
      end
    when "help"
      Help.new.run;
    else
      Help.new.run;
    end
  end
end
