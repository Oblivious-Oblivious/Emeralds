module Emeralds::Main
  private def self.ensure_em_json_or_init
    if ARGV.size > 0 && ARGV[0] != "init" && ARGV[0] != "update" && !File.exists?("em.json")
      puts "#{ARROW} em.json not found.  Please run emeralds init first.";
      exit 0;
    elsif ARGV.size == 0
      Help.new.run;
    end
  end

  private def self.validated_script(action)
    return nil unless File.exists?("em.json")

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
        Options.dispatch_template(Init, name: ARGV[1]);
      end
    when "list"
      List.new.run;
    when "install"
      if ARGV.size < 2
        Install.new.run;
      elsif ARGV[1].blank?
        puts "Invalid name: #{ARGV[1]}.".colorize(:red);
        exit 0;
      elsif ARGV[1] == "dev"
        InstallDev.new.run;
      elsif ARGV[1] == "all"
        InstallAll.new.run;
      else
        InstallLink.new(link: ARGV[1]).run;
      end
    when "build"
      Help.new.run if ARGV.size < 3;

      if ARGV[1] == "app"
        if ARGV[2] == "debug"
          Options.dispatch_template(BuildAppDebug);
        elsif ARGV[2] == "release"
          Options.dispatch_template(BuildAppRelease);
        elsif ARGV[2] == "dev"
          Options.dispatch_template(BuildAppDev);
        elsif ARGV[2] == "stage"
          Options.dispatch_template(BuildAppStage);
        elsif ARGV[2] == "preprod"
          Options.dispatch_template(BuildAppPreprod);
        elsif ARGV[2] == "prod"
          Options.dispatch_template(BuildAppProd);
        else
          Help.new.run;
        end
      elsif ARGV[1] == "lib"
        if ARGV[2] == "debug"
          Options.dispatch_template(BuildLibDebug);
        elsif ARGV[2] == "release"
          Options.dispatch_template(BuildLibRelease);
        elsif ARGV[2] == "dev"
          Options.dispatch_template(BuildLibDev);
        elsif ARGV[2] == "stage"
          Options.dispatch_template(BuildLibStage);
        elsif ARGV[2] == "preprod"
          Options.dispatch_template(BuildLibPreprod);
        elsif ARGV[2] == "prod"
          Options.dispatch_template(BuildLibProd);
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
        Options.dispatch_template(Add, name: ARGV[1]);
      end
    when "remove"
      if ARGV.size == 1
        Help.new.run;
      else
        Options.dispatch_template(Remove, name: ARGV[1]);
      end
    when "run"
      Options.dispatch_template(Run);
    when "test"
      Test.new.run;
    when "lint"
      Options.dispatch_template(Lint);
    when "update"
      Update.new.run;
    when "version"
      Version.new.run;
    when "license"
      License.new.run;
    when "clean"
      Options.dispatch_template(Clean);
    when "makefile"
      GenerateMakefile.new.run;
    when "loc"
      Loc.new.run;
    when "help"
      Help.new.run;
    else
      puts "#{ARROW} Invalid command: #{action}.".colorize(:red);
      puts "Run `em help` to see available commands.";
      exit 0;
    end
  end

  def self.run
    Options.parse_args;
    ensure_em_json_or_init;

    action = ARGV[0];
    if action != "init"
      Options.template = Emfile.instance.template;
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
