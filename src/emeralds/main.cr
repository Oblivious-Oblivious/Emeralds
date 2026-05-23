module Emeralds::Main
  private def self.ensure_em_json_or_init
    if ARGV.size > 0 && ARGV[0] != "init" && !File.exists?("em.json")
      puts "#{ARROW} em.json not found. Please run emeralds init first.";
      exit 0;
    elsif ARGV.size == 0
      Help.new.run;
    end
  end

  private def self.validated_script(action)
    scripts = Emfile.instance.scripts;
    return nil if scripts.nil?

    script = scripts[action]?;
    return nil if script.nil?

    script;
  end

  private def self.dispatch(action)
    case action
    when "init"
      if ARGV.size == 1
        Help.new.run;
      else
        Init.new(name: ARGV[1]).run;
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
    when "reinstall"
      Reinstall.new.run;
    when "uninstall"
      if ARGV.size == 1
        Help.new.run;
      else
        Uninstall.new(name: ARGV[1]).run;
      end
    when "add"
      if ARGV.size == 1
        Help.new.run;
      else
        Add.new(name: ARGV[1]).run;
      end
    when "remove"
      if ARGV.size == 1
        Help.new.run;
      else
        Remove.new(name: ARGV[1]).run;
      end
    when "run"
      Run.new.run;
    when "test"
      Test.new.run;
    when "lint"
      Lint.new.run;
    when "version"
      Version.new.run;
    when "license"
      License.new.run;
    when "clean"
      Clean.new.run;
    when "makefile"
      GenerateMakefile.new.run;
    when "loc"
      Loc.new.run;
    when "help"
      Help.new.run;
    else
      puts "#{ARROW} Invalid command: #{action}".colorize(:red);
      puts "Run `em help` to see available commands.";
      exit 0;
    end
  end

  def self.run
    ensure_em_json_or_init;

    action = ARGV[0];
    if action != "init"
      if script = validated_script(action)
        script_args = ARGV[1..].join(" ");
        if script.is_a? Array
          script.each { |cmd|
            Terminal.generic_cmd "#{cmd} #{script_args}".strip, display: true;
          };
        else
          Terminal.generic_cmd "#{script} #{script_args}".strip, display: true;
        end
      else
        dispatch action;
      end
    else
      dispatch "init";
    end
  end
end
