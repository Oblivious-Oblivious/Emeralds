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

  def self.cspec_not_on_deps
    Emfile.instance.dependencies["cSpec"];
    false;
  rescue
    true;
  end

  def self.cspec_not_on_dev_deps
    Emfile.instance.dev_dependencies["cSpec"];
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
