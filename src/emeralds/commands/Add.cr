class Emeralds::Add < Emeralds::Command
  private def write_c_file
    puts "  #{ARROW} #{ARGV[1]}.c";

    data = String.build do |data|
      data << "#include \"#{ARGV[1]}.h\"\n\n";

      data << "char *#{ARGV[1]}(void) { return \"Hello, World!\"; }\n";
    end

    File.write "src/#{ARGV[1]}/#{ARGV[1]}.c", data;
  end

  private def write_h_file
    puts "  #{ARROW} #{ARGV[1]}.h";

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

    File.write "src/#{ARGV[1]}/#{ARGV[1]}.h", data;
  end

  private def write_spec_file
    puts "  #{ARROW} #{ARGV[1]}.module.spec.h"

    data = String.build do |data|
      data << "#include \"../../libs/cSpec/export/cSpec.h\"\n\n";

      data << "#include \"../../src/#{ARGV[1]}/#{ARGV[1]}.h\"\n\n";

      data << "module(T_#{ARGV[1]}, {\n";
      data << "  describe(\"##{ARGV[1]}\", {\n";
      data << "    it(\"returns `Hello, World!`\", {\n";
      data << "      assert_that_charptr(#{ARGV[1]}() equals to \"Hello, World!\");\n";
      data << "    });\n";
      data << "  });\n";
      data << "})\n";
    end

    File.write "spec/#{ARGV[1]}/#{ARGV[1]}.module.spec.h", data;
  end

  def message
    "Adding new .c/.h pair...";
  end

  # Count the number of lines of code
  def block
    -> {
      if validate_filename ARGV[1]
        puts "#{ARROW} #{ARGV[1]}";
        TerminalHandler.mkdir "src/#{ARGV[1]}";
        write_c_file;
        write_h_file;
        TerminalHandler.mkdir "spec/#{ARGV[1]}";
        write_spec_file;
      else
        puts "Cannot create a pair with name: #{ARGV[1]}.".colorize(:light_red);
      end
    };
  end
end
