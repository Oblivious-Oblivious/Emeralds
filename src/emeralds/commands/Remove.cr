class Emeralds::Remove < Emeralds::Command
  private def update_app_header
    name = Emfile.instance.name;
    return unless name;

    app_header = File.join "src", "#{name}.h";
    return unless File.exists? app_header;

    puts "  #{ARROW} #{name}.h";

    content = File.read app_header;
    content = content.sub("#include \"#{@name}/#{@name}.h\"\n", "");

    File.write app_header, content;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.c";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.c";

    content = File.read spec_main;
    content = content.sub("#include \"#{@name}/#{@name}.module.spec.h\"\n", "");
    content = content.sub(/\s*T_#{Regex.escape(@func_name)}\(\);/, "");

    File.write spec_main, content;
  end

  def message
    "Emeralds - Removing .c/.h pair...";
  end

  def block
    -> {
      puts "#{ARROW} #{@name.colorize(:red)}";
      puts "  #{ARROW} #{@name}.c";
      puts "  #{ARROW} #{@name}.h";
      Terminal.rm File.join("src", "#{@name}");
      update_app_header;
      puts "  #{ARROW} #{@name}.module.spec.h";
      Terminal.rm File.join("spec", "#{@name}");
      update_spec_main;
    };
  end
end
