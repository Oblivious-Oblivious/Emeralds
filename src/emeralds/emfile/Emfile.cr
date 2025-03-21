class Emeralds::Emfile
  include JSON::Serializable;

  property name : String? = nil;
  property version : String? = nil;
  property dependencies :  (Hash(String, String) | Nil) = nil;

  @[JSON::Field(key: "dev-dependencies")]
  property dev_dependencies :  (Hash(String, String) | Nil) = nil;

  property build : String? = nil;

  @[JSON::Field(key: "compile-flags")]
  property compile_flags : CompileFlags = CompileFlags.new;

  property license : String? = nil;

  @@instance : Emfile?;

  private def initialize; end;

  def self.cspec_not_on_deps
    deps = Emfile.instance.dependencies;
    if deps
      deps["cSpec"];
    end
    false;
  rescue
    true;
  end

  def self.cspec_not_on_dev_deps
    depsdevs = Emfile.instance.dev_dependencies;
    if depsdevs
      depsdevs["cSpec"];
    end
    false;
  rescue
    true;
  end

  def self.instance
    @@instance ||= begin
      Emfile.from_json(File.read("em.json"));
    rescue err
      puts "Failed to load or parse em.json: #{err}".colorize(:red);
      exit 0;
    end
  end
end
