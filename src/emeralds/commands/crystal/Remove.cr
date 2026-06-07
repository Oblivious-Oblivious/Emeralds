class Emeralds::Crystal::Remove < Emeralds::Remove
  private def target_files
    [path("src", "cr"), File.join("spec", @dir_name, "#{@file_name}.spec.cr")];
  end

  private def update_libs_file
    name = Emfile.instance.name;
    return unless name;

    libs_file = File.join "src", "#{name}.libs.cr";
    return unless File.exists? libs_file;

    puts "  #{ARROW} #{name}.libs.cr";

    require_line = "require \"./#{include_path("cr").rchop(".cr")}\";\n";
    content = File.read libs_file;
    content = content.sub(require_line, "");

    File.write libs_file, content;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.cr";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.cr";

    require_line = "require \"./#{include_path("spec").rchop(".cr")}\";\n";
    content = File.read spec_main;
    content = content.sub(require_line, "");

    File.write spec_main, content;
  end

  def message
    "Emeralds - Removing .cr file...";
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
      puts "  #{ARROW} #{@base_name}.cr";
      Terminal.rm path("src", "cr");
      remove_empty_parents File.join("src", @dir_name), "src";
      update_libs_file;
      puts "  #{ARROW} #{@base_name}.spec.cr";
      Terminal.rm File.join("spec", @dir_name, "#{@file_name}.spec.cr");
      remove_empty_parents File.join("spec", @dir_name), "spec";
      update_spec_main;
    };
  end
end
