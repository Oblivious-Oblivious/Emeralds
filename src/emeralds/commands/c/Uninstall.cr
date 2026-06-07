class Emeralds::C::Uninstall < Emeralds::Uninstall
  def block
    -> {
      raw = File.read "em.json";
      escaped = Regex.escape @name;
      stripped = raw.gsub(/\n[ \t]*"[^"]*\/#{escaped}(\.git)?"\s*:\s*"[^"]*",?/, "");
      lib_path = File.join "libs", @name;
      removed_from_emfile = stripped != raw;
      removed_from_libs = File.exists? lib_path;

      if removed_from_emfile && !removed_from_libs
        File.write "em.json", stripped.gsub(/,(\n[ \t]*\})/, "\\1");
        puts "  #{COG} Removed `#{@name}` from em.json";
      end

      if removed_from_libs
        Terminal.rm lib_path;
        puts "  #{COG} Removed `#{@name}` from libs";
      end

      unless removed_from_emfile || removed_from_libs
        puts "#{ARROW} `#{@name}` not found in dependencies.".colorize(:yellow);
      end
    };
  end
end
