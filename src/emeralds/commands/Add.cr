class Emeralds::Add < Emeralds::Command
  @base_name = "";
  @file_name = "";
  @dir_name = "";
  @header_only = false;
  @source_only = false;

  def initialize(name = "", @silent = false)
    super name, @silent;
    if @name.empty?
      puts "Invalid name: #{name}.".colorize(:red);
      exit 0;
    end
    @header_only = @name.ends_with? ".h";
    @source_only = @name.ends_with? ".c";
    @base_name = @header_only ? @name.rchop(".h") : @source_only ? @name.rchop(".c") : @name;
    @file_name = File.basename @base_name;
    @dir_name = File.dirname @base_name;
    @dir_name = @base_name if @dir_name == "." && !@header_only && !@source_only;
    @dir_name = "" if @dir_name == ".";
    @func_name = @base_name.gsub(/[\s\/-]+/, "_");
  end

  private def app_name_upcase
    (Emfile.instance.name || "").gsub(/[\s-]+/, "_").upcase.strip('_');
  end

  private def path(root, ext)
    File.join root, @dir_name, "#{@file_name}.#{ext}";
  end

  private def include_path(ext)
    @dir_name.empty? ? "#{@file_name}.#{ext}" : "#{@dir_name}/#{@file_name}.#{ext}";
  end

  private def spec_include_path
    @dir_name.empty? ? "#{@file_name}.module.spec.h" : "#{@dir_name}/#{@file_name}.module.spec.h";
  end

  private def from_spec(path)
    depth = 1 + (@dir_name.empty? ? 0 : @dir_name.split('/').size);
    File.join(Array.new(depth, "..") + [path]);
  end

  private def target_files
    return [path("src", "c")] if @source_only;
    files = [path("src", "h"), File.join("spec", @dir_name, "#{@file_name}.module.spec.h")];
    files.unshift path("src", "c") unless @header_only;
    files;
  end

  private def reserved?
    @dir_name.empty? && @file_name == Emfile.instance.name;
  end

  private def write_c_file
    puts "  #{ARROW} #{@base_name}.c" unless @silent;

    data = String.build do |data|
      data << "#include \"#{@file_name}.h\"\n\n";

      data << "char *#{@func_name}(void) { return \"Hello, World!\"; }\n";
    end

    File.write path("src", "c"), data;
  end

  private def write_h_file
    puts "  #{ARROW} #{include_path("h")}" unless @silent;

    data = String.build do |data|
      data << "#ifndef __#{app_name_upcase}_#{@func_name.upcase}_H_\n";
      data << "#define __#{app_name_upcase}_#{@func_name.upcase}_H_\n\n";

      data << "/**\n";
      data << " * @brief\n";
      data << " * @return char*\n";
      data << " */\n";
      data << "char *#{@func_name}(void);\n\n";

      data << "#endif\n";
    end

    File.write path("src", "h"), data;
  end

  private def update_app_header
    name = Emfile.instance.name;
    return unless name;

    app_header = File.join "src", "#{name}.h";
    return unless File.exists? app_header;

    puts "  #{ARROW} #{name}.h" unless @silent;

    include_line = "#include \"#{include_path("h")}\"\n";
    content = File.read app_header;
    return if content.includes? include_line;

    content = content.sub(/\n#endif\n\z/, "#{include_line}\n#endif\n");
    File.write app_header, content;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.c";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.c" unless @silent;

    content = File.read spec_main;
    content = content.sub(/((?:#include "[^\n]*\n)+)/, "\\1#include \"#{spec_include_path}\"\n");
    content = content.sub(/(\s*)\}\);/) { "#{$~[1]}T_#{@func_name}();#{$~[1]}});" };

    File.write spec_main, content;
  end

  private def write_spec_file
    puts "  #{ARROW} #{@base_name}.module.spec.h" unless @silent;

    data = String.build do |data|
      data << "#ifndef __#{app_name_upcase}_#{@func_name.upcase}_MODULE_SPEC_H_\n";
      data << "#define __#{app_name_upcase}_#{@func_name.upcase}_MODULE_SPEC_H_\n\n";

      data << "#include \"#{from_spec(File.join("libs", "cSpec", "export", "cSpec.h"))}\"\n";
      data << "#include \"#{from_spec(File.join("src", include_path("h")))}\"\n\n";

      data << "module(T_#{@func_name}, {\n";
      data << "  describe(\"##{@func_name}\", {\n";
      data << "    it(\"returns `Hello, World!`\", {\n";
      data << "      assert_that_charptr(#{@func_name}() equals to \"Hello, World!\");\n";
      data << "    });\n";
      data << "  });\n";
      data << "})\n\n";

      data << "#endif\n";
    end

    File.write File.join("spec", @dir_name, "#{@file_name}.module.spec.h"), data;
  end

  def message
    "Emeralds - Adding new .c/.h pair...";
  end

  def block
    -> {
      if reserved?
        puts "#{ARROW} #{@name} is reserved by the project.".colorize(:yellow);
        exit 0;
      end

      unless target_files.none? { |file| File.exists? file }
        puts "#{ARROW} #{@name} already exists.".colorize(:yellow);
        exit 0;
      end

      puts "#{ARROW} #{@name}" unless @silent;
      Terminal.mkdir (File.join "src", @dir_name);
      write_c_file unless @header_only;

      unless @source_only
        write_h_file;
        update_app_header;
        Terminal.mkdir (File.join "spec", @dir_name);
        write_spec_file;
        update_spec_main;
      end
    };
  end
end
