# An abstract class for creating command literals
# implements a `message` and a `block` method
abstract class Emeralds::Command
  # Contains the informational message for the user while performing an Emerald command
  #
  # return -> The string to display
  abstract def message;

  # A block of code to be executed for the command
  #
  # return -> The code block
  abstract def block;

  # A random banner for enclosing output more clearly
  #
  # return -> The actual banner string
  private def banner
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end

  # Counts the elapsed time between execution blocks
  #
  # return -> A detailed string explained the time taken
  private def elapsed_time(elapsed)
    "All done in #{elapsed
      .total_seconds
      .format(decimal_places: 3)
    } seconds"
      .colorize(:white)
      .mode(:bold);
  end

  # Tries to execute the override compilation directive if it exists
  #
  # returns -> true if the override was ran else false
  private def try_override_command
    override = Emfile.instance.build;
    if override.strip != ""
      TerminalHandler.generic_cmd override, display: true;
      true;
    else
      false;
    end
  end

  private def rebuild_export
    TerminalHandler.rm "export";
    TerminalHandler.mkdir "export";
  end

  private def move_headers_to_export
    TerminalHandler.cp (File.join "src", "*"), "export";
    TerminalHandler.rm (File.join "export", "*.c");
    TerminalHandler.rm (File.join "export", "**", "*.c");
  end

  private def move_objects_to_export
    TerminalHandler.mv FileHandler.find(File.join(".", "*.o")), "export";
    TerminalHandler.cp FileHandler.find(File.join(".", "**", "*.a")), "export";
  end

  private def build_app(compile_flags)
    return if try_override_command;

    rebuild_export;

    cc = Emfile.instance.compile_flags.cc;
    opt = compile_flags.opt;
    version = compile_flags.version;
    flags = compile_flags.flags;
    warnings = compile_flags.warnings;
    deps = Emeralds.opt["app"]["deps"];
    input = Emeralds.opt["app"]["input"];
    output = Emeralds.opt["app"]["output"];
    TerminalHandler.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} -o #{output} #{deps} #{input}", display: true;
  end

  private def build_lib(compile_flags)
    return if try_override_command;

    cc = Emfile.instance.compile_flags.cc;
    opt = compile_flags.opt;
    version = compile_flags.version;
    flags = compile_flags.flags;
    warnings = compile_flags.warnings;
    input = Emeralds.opt["lib"]["input"];
    TerminalHandler.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} -c #{input}", display: true;
    rebuild_export;
    move_headers_to_export;
    move_objects_to_export;
  end

  def wget_license
    puts "  #{Emeralds.arrow} LICENSE";
    case Emfile.instance.license
    when "mit"
      TerminalHandler.wget "https://mit-license.org/license.txt", "LICENSE";
    when "gpl-v2"
      TerminalHandler.wget "https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt", "LICENSE";
    when "apache-v2"
      TerminalHandler.wget "https://www.apache.org/licenses/LICENSE-2.0.txt", "LICENSE";
    when "gpl-v3"
      TerminalHandler.wget "https://www.gnu.org/licenses/gpl-3.0.txt", "LICENSE";
    when "lgpl-v3"
      TerminalHandler.wget "https://www.gnu.org/licenses/lgpl-3.0.txt", "LICENSE";
    when "mpl-v2"
      TerminalHandler.wget "https://www.mozilla.org/media/MPL/2.0/index.f75d2927d3c1.txt", "LICENSE";
    when "epl-v2"
      TerminalHandler.wget "https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.txt", "LICENSE";
    when "agpl-v3"
      TerminalHandler.wget "https://www.gnu.org/licenses/agpl-3.0.txt", "LICENSE";
    when "cc0-v1"
      TerminalHandler.wget "https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt", "LICENSE";
    else
      TerminalHandler.wget "https://mit-license.org/license.txt", "LICENSE";
    end
  end

  def validate_filename(input)
    forbidden_chars = /[<>:"\/\\|?*\x00-\x1F]/;
    windows_reserved = /^(con|prn|aux|nul|com[1-9]|lpt[1-9]|com[0-9]+|lpt[0-9]+)$/i;

    !(input.matches? forbidden_chars) &&
    !(input.strip.empty?) &&
    !(input.strip.matches? /\A\.+\z/) &&
    !(windows_reserved.matches? input.strip);
  end

  def build_app_debug
    build_app Emfile.instance.compile_flags.debug;
  end

  def build_app_release
    build_app Emfile.instance.compile_flags.release;
  end

  def build_lib_debug
    build_lib Emfile.instance.compile_flags.debug;
  end

  def build_lib_release
    build_lib Emfile.instance.compile_flags.release;
  end

  def build_test
    # TODO - Remove duplication (2 problems)
    #   ["deps"] needs to be an app and lib value
    #   we should not rebuild export directory (maybe pass a flag)
    cc = Emfile.instance.compile_flags.cc;
    opt = Emfile.instance.compile_flags.debug.opt;
    version = Emfile.instance.compile_flags.debug.version;
    flags = Emfile.instance.compile_flags.debug.flags;
    warnings = Emfile.instance.compile_flags.debug.warnings;
    deps = Emeralds.opt["test"]["deps"];
    input = Emeralds.opt["test"]["input"];
    output = Emeralds.opt["test"]["output"];
    TerminalHandler.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} -o #{output} #{deps} #{input}", display: true;
    puts;
    TerminalHandler.run output, display: true;
  end

  # Main method that runs and times the command block.
  def run
    puts message.colorize(:white).mode(:bold);
    puts banner;

    elapsed = Time.measure { block.call; };

    puts banner;
    puts elapsed_time elapsed;
  end
end
