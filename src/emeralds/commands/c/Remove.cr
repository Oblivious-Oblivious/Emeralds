class Emeralds::C::Remove < Emeralds::Remove
  @header_only = false;
  @source_only = false;

  def initialize(name = "", @silent = false)
    super name, @silent;
    @header_only = @name.ends_with? ".h";
    @source_only = @name.ends_with? ".c";
    @base_name = @name.without_c_extension;
    @file_name = File.basename @base_name;
    @dir_name = File.dirname @base_name;
    @dir_name = @base_name if @dir_name == "." && !@header_only && !@source_only;
    @dir_name = "" if @dir_name == ".";
    @func_name = @base_name.to_c_identifier;
  end

  private def spec_include_path
    @dir_name.empty? ? "#{@file_name}.module.spec.h" : "#{@dir_name}/#{@file_name}.module.spec.h";
  end

  private def target_files
    return [path("src", "c")] if @source_only;
    files = [path("src", "h"), File.join("spec", @dir_name, "#{@file_name}.module.spec.h")];
    files.unshift path("src", "c") unless @header_only;
    files;
  end

  private def update_app_header
    name = Emfile.instance.name;
    return unless name;

    app_header = File.join "src", "#{name}.h";
    return unless File.exists? app_header;

    puts "  #{ARROW} #{name}.h";

    content = File.read app_header;
    content = content.sub("#include \"#{include_path("h")}\"\n", "");

    File.write app_header, content;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.c";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.c";

    content = File.read spec_main;
    content = content.sub("#include \"#{spec_include_path}\"\n", "");
    content = content.sub(/\s*T_#{Regex.escape(@func_name)}\(\);/, "");

    File.write spec_main, content;
  end

  def message
    "Emeralds - Removing .c/.h pair...";
  end

  def block
    -> {
      if reserved?
        puts "#{ARROW} #{@name} is reserved by the project.".colorize(:yellow);
        exit 0;
      end

      if target_files.none? { |file| File.exists? file }
        puts "#{ARROW} #{@name} does not exist".colorize(:yellow);
        exit 0;
      end

      puts "#{ARROW} #{@name.colorize(:red)}";

      if @source_only
        puts "  #{ARROW} #{@base_name}.c";
        Terminal.rm path("src", "c");
      else
        unless @header_only
          puts "  #{ARROW} #{@base_name}.c";
          Terminal.rm path("src", "c");
        end
        puts "  #{ARROW} #{include_path("h")}";
        Terminal.rm path("src", "h");
        remove_empty_parents File.join("src", @dir_name), "src";
        update_app_header;
        puts "  #{ARROW} #{@base_name}.module.spec.h";
        Terminal.rm File.join("spec", @dir_name, "#{@file_name}.module.spec.h");
        remove_empty_parents File.join("spec", @dir_name), "spec";
        update_spec_main;
      end
    };
  end
end
