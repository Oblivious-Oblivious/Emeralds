class Emeralds::Uninstall < Emeralds::Command
  def message
    "Emeralds - Uninstalling dependency...";
  end

  def block
    -> {
      raw = File.read "em.json";
      escaped = Regex.escape @name;
      updated = raw.gsub(/\n[ \t]*"#{escaped}"\s*:\s*"[^"]*",?/, "");

      if updated == raw
        puts "#{ARROW} `#{@name}` not found in dependencies".colorize(:yellow);
        exit 0;
      end

      updated = updated.gsub(/,(\n[ \t]*\})/, "\\1");
      File.write "em.json", updated;
      puts "  #{COG} Removed `#{@name}` from em.json";

      lib_path = File.join "libs", @name;
      if File.exists? lib_path
        Terminal.rm lib_path;
      end
    };
  end
end
