class Emeralds::InstallLink < Emeralds::Command
  @link = "";

  def initialize(link = "")
    super "";
    @link = link.strip;
    if @link.empty?
      puts "Invalid name: #{link}.".colorize(:red);
      exit 0;
    end
  end

  private def add_dependency(link)
    raw = File.read "em.json";
    return if raw.includes? "\"#{link}\"";

    entry = "    \"#{link}\": \"latest\"";
    updated = raw.sub /("dependencies"\s*:\s*\{)\s*\}/, "\\1\n#{entry}\n  }";
    updated = raw.sub /("dependencies"\s*:\s*\{)/, "\\1\n#{entry}," if updated == raw;

    File.write "em.json", updated;
  end

  def message
    "Emeralds - Installing `#{@link}`...";
  end

  def block
    -> {
      Terminal.mkdir "libs";
      add_dependency @link;
      Install.new.install_deps({@link => "latest"});
    };
  end
end
