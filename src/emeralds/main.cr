module Emeralds::Main
  BUILT_IN_COMMANDS = [
    "add",
    "build",
    "clean",
    "help",
    "init",
    "install",
    "license",
    "list",
    "loc",
    "makefile",
    "reinstall",
    "run",
    "test",
    "version",
  ];

  RESERVED_SCRIPT_NAMES = BUILT_IN_COMMANDS + [
    "build-override",
    "compile-flags",
    "dependencies",
    "dev-dependencies",
    "name",
    "scripts",
    "version",
  ];

  private def self.ensure_em_json_or_init
    if ARGV.size > 0 && ARGV[0] != "init" && !File.exists?("em.json")
      puts "#{ARROW} em.json not found. Please run emeralds init first.";
      exit 0;
    elsif ARGV.size == 0
      Help.new.run;
    end
  end

  private def self.invalid_command(action)
    puts "#{ARROW} Invalid command: #{action}".colorize(:red);
    puts "Run `em help` to see available commands.";
    exit 0;
  end

  private def self.validate_script_names
    return unless File.exists?("em.json");

    scripts = Emfile.instance.scripts;
    return unless scripts;

    conflicts = scripts.keys.select { |name| RESERVED_SCRIPT_NAMES.includes? name };
    return if conflicts.empty?;

    puts "#{ARROW} Invalid script name#{conflicts.size == 1 ? "" : "s"}: #{conflicts.join(", ")}".colorize(:red);
    puts "Scripts cannot use existing command or em.json field names.";
    exit 0;
  end

  private def self.run_script(action)
    scripts = Emfile.instance.scripts;
    return false unless scripts;

    script = scripts[action]?;
    return false unless script;

    script = script.strip;
    if script.empty?
      puts "#{ARROW} Script `#{action}` is empty.".colorize(:red);
      exit 0;
    end

    puts "#{ARROW} #{script}";
    system script;
    true;
  end

  private def self.dispatch(action)
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
    when "reinstall"
      Reinstall.new.run;
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
      invalid_command action unless run_script(action);
    end
  end

  def self.run
    ensure_em_json_or_init;
    validate_script_names if ARGV[0] != "init";

    action = ARGV[0];
    dispatch action;
  end
end
