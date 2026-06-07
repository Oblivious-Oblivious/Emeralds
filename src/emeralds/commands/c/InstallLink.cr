class Emeralds::C::InstallLink < Emeralds::InstallLink
  private def add_dependency(link)
    raw = File.read "em.json";
    return if raw.includes? "\"#{link}\"";

    entry = "    \"#{link}\": \"latest\"";
    updated = raw.sub /("dependencies"\s*:\s*\{)\s*\}/, "\\1\n#{entry}\n  }";
    updated = raw.sub /("dependencies"\s*:\s*\{)/, "\\1\n#{entry}," if updated == raw;

    File.write "em.json", updated;
  end

  def block
    -> {
      Terminal.mkdir "libs";
      add_dependency @link;
      C::Install.new.install_deps({@link => "latest"});
    };
  end
end
