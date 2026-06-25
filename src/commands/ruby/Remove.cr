class Emeralds::Ruby::Remove < Emeralds::Remove
  private def spec_file_name
    "#{@file_name}_spec.rb";
  end

  private def spec_relative_path
    @dir_name.empty? ? spec_file_name : "#{@dir_name}/#{spec_file_name}";
  end

  private def src_relative_path
    @dir_name.empty? ? "#{@file_name}.rb" : "#{@dir_name}/#{@file_name}.rb";
  end

  private def target_files
    [path("src", "rb"), File.join("spec", @dir_name, spec_file_name)];
  end

  private def update_requires_file
    name = Emfile.instance.name;
    return unless name;

    requires_file = File.join "src", "#{name}.rb";
    return unless File.exists? requires_file;

    puts "  #{ARROW} #{name}.rb";

    require_line = "require_relative \"#{src_relative_path.rchop(".rb")}\";\n";
    content = File.read requires_file;
    content = content.sub(require_line, "");

    File.write requires_file, content;
  end

  private def update_spec_main
    spec_main = File.join "spec", "spec_helper.rb";
    return unless File.exists? spec_main;

    puts "  #{ARROW} spec_helper.rb";

    require_line = "require_relative \"./#{spec_relative_path.rchop(".rb")}\";\n";
    content = File.read spec_main;
    content = content.sub(require_line, "");

    File.write spec_main, content;
  end

  def message
    "Emeralds - Removing .rb file...";
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
      puts "  #{ARROW} #{@base_name}.rb";
      Terminal.rm path("src", "rb");
      remove_empty_parents File.join("src", @dir_name), "src";
      update_requires_file;
      puts "  #{ARROW} #{@base_name}_spec.rb";
      Terminal.rm File.join("spec", @dir_name, spec_file_name);
      remove_empty_parents File.join("spec", @dir_name), "spec";
      update_spec_main;
    };
  end
end
