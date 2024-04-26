class Emeralds::Add < Emeralds::Command
  private def sanitize_filename(input)
    forbidden_chars = /[<>:"\/\\|?*\x00-\x1F]/;
    windows_reserved = /^(con|prn|aux|nul|com[1-9]|lpt[1-9])(\.\w+)?$/i;
    sanitized = input.gsub forbidden_chars, "_";

    if windows_reserved.match sanitized
      sanitized = "file_#{sanitized}";
    end

    sanitized;
  end

  private def write_c_file
    puts "  #{ARROW} #{ARGV[1]}.c";

    data = String.build do |data|
      data << "#include \"#{ARGV[1]}.h\"\n\n";

      data << "void #{ARGV[1]}_dummy(void) {}\n\n";
    end

    File.write "src/#{ARGV[1]}/#{ARGV[1]}.c", data;
  end

  private def write_h_file
    puts "  #{ARROW} #{ARGV[1]}.h";

    data = String.build do |data|
      data << "#ifndef __#{ARGV[1].gsub("-", "_").upcase}_H_\n";
      data << "#define __#{ARGV[1].gsub("-", "_").upcase}_H_\n\n";

      data << "void #{ARGV[1]}_dummy(void);\n\n";

      data << "#endif\n";
    end

    File.write "src/#{ARGV[1]}/#{ARGV[1]}.h", data;
  end

  def message
    "Adding new .c/.h pair...";
  end

  # Count the number of lines of code
  def block
    -> {
      if sanitize_filename ARGV[1]
        TerminalHandler.mkdir "src/#{ARGV[1]}";
        write_c_file;
        write_h_file;
      else
        puts "Cannot create a pair with name: #{ARGV[1]}.".colorize(:light_red);
      end
    };
  end
end
