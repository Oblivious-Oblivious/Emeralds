class Emeralds::Emfile
  include JSON::Serializable;

  property name : String = "";
  property version : String = "";
  property dependencies : Hash(String, String) = {} of String => String;

  @[JSON::Field(key: "dev-dependencies")]
  property dev_dependencies : Hash(String, String) = {} of String => String;

  property build : String = "";

  @[JSON::Field(key: "compile-flags")]
  property compile_flags : CompileFlags = CompileFlags.new;

  property license : String = "";

  @@instance : Emfile?;

  private def initialize; end;

  private def self.cspec_not_on_deps
    Emfile.instance.dependencies["cSpec"];
    false;
  rescue
    true;
  end

  private def self.cspec_not_on_dev_deps
    Emfile.instance.dev_dependencies["cSpec"];
    false;
  rescue
    true;
  end

  def self.instance
    @@instance ||= begin
      Emfile.from_json(File.read("em.json"));
    rescue err
      puts "Failed to load or parse em.json: #{err}".colorize(:light_red);
      exit 0;
    end
  end

  # Check if the cspec dependency is defined in the emfile
  def self.cspec_dep_does_not_exist
    cspec_not_on_deps && cspec_not_on_dev_deps;
  end

  # Check if cspec is installed
  def self.cspec_exists
    File.exists? File.join("libs", "cSpec", "export", "cSpec.h");
  end

  # List a list of dependencies from the emfile.
  def self.list(deps)
    deps.sanitize.each do |key, value|
      puts "  #{Emeralds.cog} #{key}";
    end
  end

  # Install a list of dependencies and their own dependencies recursively
  #
  # deps -> The list of dependecies to install
  def self.install_deps(deps)
    deps.sanitize.each do |key, value|
      TerminalHandler.rm (File.join "libs", "#{key}");
      puts " #{Emeralds.cog} Installing `#{key}`";

      TerminalHandler.git_clone "https://github.com/#{value}", (File.join "libs", "#{key}");
      Dir.cd (File.join "libs", "#{key}");
      TerminalHandler.generic_cmd "em install";
      TerminalHandler.generic_cmd "em build lib release 2> /dev/null";
      FileHandler.delete_excluded_paths ".", ["export", "libs"];

      `rm -rf .git*`;
      `rm -rf .clang*`;
      Dir.cd (File.join "..", "..");
    end
  end
end
