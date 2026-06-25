class Emeralds::Ruby::Add < Emeralds::Add
  private def module_name
    @base_name.to_ruby_crystal_namespace;
  end

  private def project_namespace
    (Emfile.instance.name || "").to_ruby_crystal_namespace;
  end

  private def spec_file_name
    "#{@file_name}_spec.rb";
  end

  private def spec_relative_path
    @dir_name.empty? ? spec_file_name : "#{@dir_name}/#{spec_file_name}";
  end

  private def src_relative_path
    @dir_name.empty? ? "#{@file_name}.rb" : "#{@dir_name}/#{@file_name}.rb";
  end

  private def src_require_from_spec
    depth = 1 + (@dir_name.empty? ? 0 : @dir_name.split('/').size);
    "../" * depth + "src/#{src_relative_path.rchop(".rb")}";
  end

  private def target_files
    [path("src", "rb"), File.join("spec", @dir_name, spec_file_name)];
  end

  private def write_ruby_file
    puts "  #{ARROW} #{@base_name}.rb" unless @silent;

    parts = module_name.split("::");
    indent = "  ";
    opens = String.build do |data|
      data << "# frozen_string_literal: true\n\n";

      data << "module #{project_namespace}\n";
      parts[0...-1].each do |part|
        data << "#{indent}module #{part}\n";
        indent += "  ";
      end
      data << "#{indent}# Top-level class for #{module_name}.\n";
      data << "#{indent}class #{parts.last}\n";
      indent += "  ";
    end

    body = String.build do |data|
      data << "#{indent}def value\n";
      data << "#{indent}  \"Hello, World!\";\n";
      data << "#{indent}end\n";
    end

    closes = String.build do |data|
      indent = indent.rchop("  ");
      data << "#{indent}end\n";
      parts[0...-1].reverse_each do
        indent = indent.rchop("  ");
        data << "#{indent}end\n";
      end
      data << "end\n";
    end

    File.write path("src", "rb"), opens + body + closes;
  end

  private def update_requires_file
    name = Emfile.instance.name;
    return unless name;

    requires_file = File.join "src", "#{name}.rb";
    return unless File.exists? requires_file;

    puts "  #{ARROW} #{name}.rb" unless @silent;

    require_line = "require_relative \"#{src_relative_path.rchop(".rb")}\";\n";
    content = File.read requires_file;
    return if content.includes? require_line;

    lines = content.lines(chomp: true);
    last_require = lines.rindex(&.starts_with?("require"));
    if last_require
      lines.insert(last_require + 1, require_line.rchop("\n"));
      content = lines.join("\n") + "\n";
    else
      content = content.rstrip + "\n#{require_line}";
    end
    File.write requires_file, content;
  end

  private def write_spec_file
    puts "  #{ARROW} #{@base_name}_spec.rb" unless @silent;

    result = String.build do |data|
      data << "# frozen_string_literal: true\n\n";

      data << "require_relative \"#{src_require_from_spec}\";\n\n";

      data << "RSpec.describe #{project_namespace}::#{module_name} do\n";
      data << "  it \"returns Hello, World!\" do\n";
      data << "    expect(#{project_namespace}::#{module_name}.new.value).to eq(\"Hello, World!\");\n";
      data << "  end\n";
      data << "end\n";
    end

    File.write File.join("spec", @dir_name, spec_file_name), result;
  end

  private def update_spec_main
    spec_main = File.join "spec", "spec_helper.rb";
    return unless File.exists? spec_main;

    puts "  #{ARROW} spec_helper.rb" unless @silent;

    require_line = "require_relative \"./#{spec_relative_path.rchop(".rb")}\";\n";
    content = File.read spec_main;
    return if content.includes? require_line;

    content = content.rstrip + "\n#{require_line}";
    File.write spec_main, content;
  end

  def message
    "Emeralds - Adding new .rb file...";
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
      write_ruby_file;
      update_requires_file;
      Terminal.mkdir(File.join "spec", @dir_name);
      write_spec_file;
      update_spec_main;
    };
  end
end
