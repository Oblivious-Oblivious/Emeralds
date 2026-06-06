class Emeralds::Crystal::Add < Emeralds::Add
  private def module_name
    @base_name.split(/[\s\/_-]+/).reject(&.empty?).map(&.capitalize).join;
  end

  private def target_files
    [path("src", "cr"), File.join("spec", @dir_name, "#{@file_name}.spec.cr")];
  end

  private def write_crystal_file
    puts "  #{ARROW} #{@base_name}.cr" unless @silent;

    result = String.build do |data|
      data << "def #{@func_name}\n";
      data << "  \"Hello, World!\";\n";
      data << "end\n";
    end

    File.write path("src", "cr"), result;
  end

  private def update_libs_file
    name = Emfile.instance.name;
    return unless name;

    libs_file = File.join "src", "#{name}.libs.cr";
    return unless File.exists? libs_file;

    puts "  #{ARROW} #{name}.libs.cr" unless @silent;

    require_line = "require \"./#{include_path("cr").rchop(".cr")}\";\n";
    content = File.read libs_file;
    return if content.includes? require_line;

    content = content.rstrip + "\n#{require_line}";
    File.write libs_file, content;
  end

  private def write_spec_file
    puts "  #{ARROW} #{@base_name}.spec.cr" unless @silent;

    result = String.build do |data|
      data << "describe \"##{@func_name}\" do\n";
      data << "  it \"returns Hello, World!\" do\n";
      data << "    #{@func_name}.should eq \"Hello, World!\";\n";
      data << "  end\n";
      data << "end\n";
    end

    File.write File.join("spec", @dir_name, "#{@file_name}.spec.cr"), result;
  end

  private def update_spec_main
    name = Emfile.instance.name;
    return unless name;

    spec_main = File.join "spec", "#{name}.spec.cr";
    return unless File.exists? spec_main;

    puts "  #{ARROW} #{name}.spec.cr" unless @silent;

    require_line = "require \"./#{include_path("spec").rchop(".cr")}\";\n";
    content = File.read spec_main;
    return if content.includes? require_line;

    content = content.rstrip + "\n#{require_line}";
    File.write spec_main, content;
  end

  def message
    "Emeralds - Adding new .cr file...";
  end

  def block
    -> {
      if reserved?
        puts "#{ARROW} #{@name} is reserved by the project.".colorize(:yellow);
        exit 0;
      end

      if target_files.any? { |file| File.exists? file }
        puts "#{ARROW} #{@name} already exists.".colorize(:yellow);
        exit 0;
      end

      puts "#{ARROW} #{@name}" unless @silent;
      Terminal.mkdir(File.join "src", @dir_name);
      write_crystal_file;
      update_libs_file;
      Terminal.mkdir(File.join "spec", @dir_name);
      write_spec_file;
      update_spec_main;
    };
  end
end
