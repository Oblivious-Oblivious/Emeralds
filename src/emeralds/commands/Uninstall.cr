class Emeralds::Uninstall < Emeralds::Command
  def message
    "Emeralds - Uninstalling dependency...";
  end

  def block
    -> {
      dep_name = ARGV[1];

      raw = File.read "em.json";
      escaped = Regex.escape dep_name;
      updated = raw.gsub(/\n[ \t]*"#{escaped}"\s*:\s*"[^"]*",?/, "");

      if updated == raw
        puts "#{ARROW} `#{dep_name}` not found in dependencies".colorize(:yellow);
        exit 0;
      end

      updated = updated.gsub(/,(\n[ \t]*\})/, "\\1");
      File.write "em.json", updated;
      puts "  #{COG} Removed `#{dep_name}` from em.json";

      lib_path = File.join "libs", dep_name;
      if File.exists? lib_path
        Terminal.rm lib_path;
      end
    };
  end
end
