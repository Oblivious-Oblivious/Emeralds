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

  private def try_override_command
    override = Emfile.instance.build;
    if override.strip != ""
      Terminal.generic_cmd override, display: true;
      true;
    else
      false;
    end
  end

  private def move_headers_to_export
    Terminal.cp (File.join "src", "*"), "export";
    Terminal.rm (File.join "export", "*.c");
    Terminal.rm (File.join "export", "**", "*.c");
  end

  private def remove_objects_and_move_static_libs_to_export
    Terminal.rm Terminal.find(File.join(".", "*.o"));
    Terminal.mv Terminal.find(File.join(".", "**", "*.a")), "export";
    Terminal.mv Terminal.find(File.join(".", "**", "*.a.test")), "export";
  end

  private def delete_excluded_paths(base_dir, exclude_patterns)
    base_dir_path = Path[base_dir];
    Dir.glob(base_dir_path.join("**", "{*,.*}")) do |path|
      path = Path[path];
      relative_path = path.relative_to(base_dir_path).to_s.lchop('/');
      next if exclude_patterns.any? do |pattern|
        pattern = pattern.lchop("./");
        pattern == relative_path || relative_path.starts_with?("#{pattern}/");
      end
      FileUtils.rm_rf(path.to_s) unless File.directory?(path.to_s) && path == base_dir_path;
    end
  end

  private def build_app(compile_flags)
    return if try_override_command;

    Terminal.mkdir "export";

    if Terminal.sources_app.empty? && Terminal.input_app.empty?
      print "#{ARROW} ";
      puts "No main file found".colorize(:red);
    else
      Terminal.generic_cmd "\
        #{Emfile.instance.compile_flags.cc} \
        #{compile_flags.opt} \
        #{compile_flags.version} \
        #{compile_flags.flags} \
        #{compile_flags.warnings} \
        -o #{Terminal.output_app} \
        #{Terminal.deps_release} \
        #{Terminal.sources_app} \
        #{Terminal.input_app} \
      ", display: true;
    end
  end

  private def build_lib(compile_flags)
    return if try_override_command;

    cc = Emfile.instance.compile_flags.cc;
    opt = compile_flags.opt;
    version = compile_flags.version;
    flags = compile_flags.flags;
    warnings = compile_flags.warnings;
    deps = Terminal.deps_release;
    sources = Terminal.sources_lib;
    output = Terminal.output_lib;
    if !sources.empty?
      Terminal.generic_cmd "#{cc} #{opt} #{version} #{flags} #{warnings} -c #{sources}", display: true;
      Terminal.generic_cmd "#{cc} -o #{output} -r *.o", display: true;
      Terminal.generic_cmd "#{cc} #{opt} -std=c2x #{flags} #{warnings} -c #{sources}", display: true;
      Terminal.generic_cmd "#{cc} -o #{output}.test -r *.o", display: true;
    end
    Terminal.mkdir "export";
    move_headers_to_export;
    remove_objects_and_move_static_libs_to_export;
  end

  def install_deps(deps)
    deps.sanitize.each do |key, value|
      if !File.exists? (File.join "libs", "#{key}")
        puts " #{COG} Installing `#{key}`";

        Terminal.git_clone "https://github.com/#{value}", (File.join "libs", "#{key}");
        Dir.cd (File.join "libs", "#{key}");
        Terminal.generic_cmd "em install";
        Terminal.generic_cmd "em build lib release 2> /dev/null";
        delete_excluded_paths ".", ["export", "libs"];

        `rm -rf .git*`;
        `rm -rf .clang*`;
        Dir.cd (File.join "..", "..");
      else
        puts " #{COG} `#{key}` already installed";
      end
    end
  end

  def wget_license
    puts "  #{ARROW} LICENSE";
    case Emfile.instance.license
    when "mit"
      Terminal.wget "https://mit-license.org/license.txt", "LICENSE";
    when "gpl-v2"
      Terminal.wget "https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt", "LICENSE";
    when "apache-v2"
      Terminal.wget "https://www.apache.org/licenses/LICENSE-2.0.txt", "LICENSE";
    when "gpl-v3"
      Terminal.wget "https://www.gnu.org/licenses/gpl-3.0.txt", "LICENSE";
    when "lgpl-v3"
      Terminal.wget "https://www.gnu.org/licenses/lgpl-3.0.txt", "LICENSE";
    when "mpl-v2"
      Terminal.wget "https://www.mozilla.org/media/MPL/2.0/index.f75d2927d3c1.txt", "LICENSE";
    when "epl-v2"
      Terminal.wget "https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.txt", "LICENSE";
    when "agpl-v3"
      Terminal.wget "https://www.gnu.org/licenses/agpl-3.0.txt", "LICENSE";
    when "cc0-v1"
      Terminal.wget "https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt", "LICENSE";
    when "cc0-v4"
      Terminal.wget "https://creativecommons.org/licenses/by/4.0/legalcode.txt", "LICENSE";
    else
      Terminal.wget "https://mit-license.org/license.txt", "LICENSE";
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

  def run
    puts message.colorize(:white).mode(:bold);
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);

    elapsed = Time.measure { block.call; };

    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
    puts "All done in #{elapsed
      .total_seconds
      .format(decimal_places: 3)
    } seconds"
      .colorize(:white)
      .mode(:bold);
  end
end
