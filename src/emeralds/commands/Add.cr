class Emeralds::Add < Emeralds::Command
  @silent = false;

  def initialize(@silent = false)
  end

  private def write_c_file
    puts "  #{ARROW} #{ARGV[1]}.c" unless @silent;

    data = String.build do |data|
      data << "#include \"#{ARGV[1]}.h\"\n\n";

      data << "char *#{ARGV[1]}(void) { return \"Hello, World!\"; }\n";
    end

    File.write (File.join "src", "#{ARGV[1]}", "#{ARGV[1]}.c"), data;
  end

  private def write_h_file
    puts "  #{ARROW} #{ARGV[1]}.h" unless @silent;

    data = String.build do |data|
      data << "#ifndef __#{ARGV[1].gsub("-", "_").upcase}_H_\n";
      data << "#define __#{ARGV[1].gsub("-", "_").upcase}_H_\n\n";

      data << "/**\n";
      data << " * @brief\n";
      data << " * @return char*\n";
      data << " */\n";
      data << "char *#{ARGV[1]}(void);\n\n";

      data << "#endif\n";
    end

    File.write (File.join "src", "#{ARGV[1]}", "#{ARGV[1]}.h"), data;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.c";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.c" unless @silent;

    content = File.read spec_main;
    content = content.sub(/((?:#include "[^\n]*\n)+)/, "\\1#include \"#{ARGV[1]}/#{ARGV[1]}.module.spec.h\"\n");
    content = content.sub(/(\s*)\}\);/) { "#{$~[1]}T_#{ARGV[1]}();#{$~[1]}});" };

    File.write spec_main, content;
  end

  private def write_spec_file
    puts "  #{ARROW} #{ARGV[1]}.module.spec.h" unless @silent;

    data = String.build do |data|
      data << "#include \"../../libs/cSpec/export/cSpec.h\"\n";
      data << "#include \"../../src/#{ARGV[1]}/#{ARGV[1]}.h\"\n\n";

      data << "module(T_#{ARGV[1]}, {\n";
      data << "  describe(\"##{ARGV[1]}\", {\n";
      data << "    it(\"returns `Hello, World!`\", {\n";
      data << "      assert_that_charptr(#{ARGV[1]}() equals to \"Hello, World!\");\n";
      data << "    });\n";
      data << "  });\n";
      data << "})\n";
    end

    File.write (File.join "spec", "#{ARGV[1]}", "#{ARGV[1]}.module.spec.h"), data;
  end

  def message
    "Emeralds - Adding new .c/.h pair...";
  end

  def block
    -> {
      if validate_filename ARGV[1]
        puts "#{ARROW} #{ARGV[1]}" unless @silent;
        Terminal.mkdir (File.join "src", "#{ARGV[1]}");
        write_c_file;
        write_h_file;
        Terminal.mkdir (File.join "spec", "#{ARGV[1]}");
        write_spec_file;
        update_spec_main;
      else
        puts "Cannot create a pair with name: #{ARGV[1]}.".colorize(:red);
      end
    };
  end
end
