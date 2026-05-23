class Emeralds::Add < Emeralds::Command
  private def app_name_upcase
    (Emfile.instance.name || "").gsub(/[\s-]+/, "_").upcase;
  end

  private def write_c_file
    puts "  #{ARROW} #{@name}.c" unless @silent;

    data = String.build do |data|
      data << "#include \"#{@name}.h\"\n\n";

      data << "char *#{@func_name}(void) { return \"Hello, World!\"; }\n";
    end

    File.write (File.join "src", "#{@name}", "#{@name}.c"), data;
  end

  private def write_h_file
    puts "  #{ARROW} #{@name}.h" unless @silent;

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

    File.write (File.join "src", "#{@name}", "#{@name}.h"), data;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.c";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.c" unless @silent;

    content = File.read spec_main;
    content = content.sub(/((?:#include "[^\n]*\n)+)/, "\\1#include \"#{@name}/#{@name}.module.spec.h\"\n");
    content = content.sub(/(\s*)\}\);/) { "#{$~[1]}T_#{@func_name}();#{$~[1]}});" };

    File.write spec_main, content;
  end

  private def write_spec_file
    puts "  #{ARROW} #{@name}.module.spec.h" unless @silent;

    data = String.build do |data|
      data << "#ifndef __#{app_name_upcase}_#{@func_name.upcase}_MODULE_SPEC_H_\n";
      data << "#define __#{app_name_upcase}_#{@func_name.upcase}_MODULE_SPEC_H_\n\n";

      data << "#include \"../../libs/cSpec/export/cSpec.h\"\n";
      data << "#include \"../../src/#{@name}/#{@name}.h\"\n\n";

      data << "module(T_#{@func_name}, {\n";
      data << "  describe(\"##{@func_name}\", {\n";
      data << "    it(\"returns `Hello, World!`\", {\n";
      data << "      assert_that_charptr(#{@func_name}() equals to \"Hello, World!\");\n";
      data << "    });\n";
      data << "  });\n";
      data << "})\n\n";

      data << "#endif\n";
    end

    File.write (File.join "spec", "#{@name}", "#{@name}.module.spec.h"), data;
  end

  def message
    "Emeralds - Adding new .c/.h pair...";
  end

  def block
    -> {
      puts "#{ARROW} #{@name}" unless @silent;
      Terminal.mkdir (File.join "src", "#{@name}");
      write_c_file;
      write_h_file;
      Terminal.mkdir (File.join "spec", "#{@name}");
      write_spec_file;
      update_spec_main;
    };
  end
end
