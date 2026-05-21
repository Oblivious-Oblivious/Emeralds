class Emeralds::Remove < Emeralds::Command
  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.c";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.c";

    content = File.read spec_main;
    content = content.sub("#include \"#{ARGV[1]}/#{ARGV[1]}.module.spec.h\"\n", "");
    content = content.sub(/\s*T_#{Regex.escape(ARGV[1])}\(\);/, "");

    File.write spec_main, content;
  end

  def message
    "Emeralds - Removing .c/.h pair...";
  end

  def block
    -> {
      if validate_filename ARGV[1]
        puts "#{ARROW} #{ARGV[1].colorize(:red)}";
        puts "  #{ARROW} #{ARGV[1]}.c";
        puts "  #{ARROW} #{ARGV[1]}.h";
        Terminal.rm File.join("src", "#{ARGV[1]}");
        puts "  #{ARROW} #{ARGV[1]}.module.spec.h";
        Terminal.rm File.join("spec", "#{ARGV[1]}");
        update_spec_main;
      else
        puts "Cannot remove a pair with name: #{ARGV[1]}.".colorize(:red);
      end
    };
  end
end
