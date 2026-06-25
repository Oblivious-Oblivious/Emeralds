class Emeralds::Ruby::Init < Emeralds::Init
  private def module_name
    @name.to_ruby_crystal_namespace;
  end

  private def write_gemfile
    puts "  #{ARROW} Gemfile";

    result = String.build do |data|
      data << "source \"https://rubygems.org\";\n\n";

      data << "group :development do\n";
      data << "  gem \"rspec\";\n";
      data << "  gem \"rubocop\";\n";
      data << "  gem \"rubocop-performance\";\n";
      data << "  gem \"yard\";\n";
      data << "end\n";
    end

    File.write "Gemfile", result;
  end

  private def write_em_json
    puts "  #{ARROW} em.json";

    File.write "em.json", {
      "$schema"   => "https://raw.githubusercontent.com/Oblivious-Oblivious/Emeralds/master/schema/em.schema.json",
      "author"    => Options.author,
      "name"      => @name,
      "template"  => Options.template,
      "version"   => "0.0.1",
      "license"   => "mit",
      "locignore" => {
        "extensions"  => [] of String,
        "directories" => [".opencode", ".claude"],
      },
      "lintignore" => {
        "extensions"  => [] of String,
        "directories" => [] of String,
      },
      "scripts"       => {} of String => String,
      "compile-flags" => {
        "darwin" => {
          "debug"   => ["ruby"],
          "release" => ["ruby"],
        },
        "linux" => {
          "debug"   => ["ruby"],
          "release" => ["ruby"],
        },
        "win32" => {
          "debug"   => ["ruby"],
          "release" => ["ruby"],
        },
      },
      "dependencies"     => {} of String => String,
      "dev-dependencies" => {} of String => String,
    }.to_pretty_json + "\n";
  end

  private def create_src_main
    puts "    #{ARROW} #{@name}.rb";

    result = String.build do |data|
      data << "# frozen_string_literal: true\n\n";

      data << "require_relative \"get-value/get-value\";\n\n";

      data << "puts #{module_name}::GetValue.new.value;\n";
    end

    File.write (File.join "src", "#{@name}.rb"), result;
  end

  private def write_source_files
    puts "  #{ARROW} src";
    Terminal.mkdir "src";
    puts "    #{ARROW} get-value";
    puts "      #{ARROW} get-value.rb";
    create_src_main;
    Ruby::Add.new(name: "get-value", silent: true).block.call;
  end

  private def create_spec_helper
    puts "    #{ARROW} spec_helper.rb";

    result = String.build do |data|
      data << "# frozen_string_literal: true\n\n";

      data << "require \"rspec\";\n";
      data << "require_relative \"../src/#{@name}\";\n\n";

      data << "require_relative \"./get-value/get-value_spec\";\n";
    end

    File.write (File.join "spec", "spec_helper.rb"), result;
  end

  private def write_spec_files
    puts "  #{ARROW} spec";
    Terminal.mkdir "spec";
    puts "    #{ARROW} get-value";
    puts "      #{ARROW} get-value_spec.rb";
    create_spec_helper;
  end

  private def write_gitignore_file
    puts "  #{ARROW} .gitignore";

    result = String.build do |data|
      data << "/.bundle/\n";
      data << "/.yardoc\n";
      data << "/doc/\n";
      data << "/coverage/\n";
      data << "/pkg/\n";
      data << "/spec/reports/\n";
      data << "/tmp/\n";
      data << "/bin/\n\n";

      data << "# MacOS\n";
      data << ".DS_Store\n\n";

      data << "# AI\n";
      data << ".claude\n";
      data << ".opencode\n";
    end

    File.write ".gitignore", result;
  end

  private def write_rubocop_yml
    puts "  #{ARROW} .rubocop.yml";

    result = String.build do |data|
      data << "require: rubocop-performance\n\n";

      data << "AllCops:\n";
      data << "  NewCops: enable\n";
      data << "  TargetRubyVersion: 3.0\n";
      data << "Naming/FileName:\n";
      data << "  Enabled: false\n";
      data << "Style/Semicolon:\n";
      data << "  Enabled: false\n";
      data << "Style/StringLiterals:\n";
      data << "  EnforcedStyle: double_quotes\n";
      data << "Naming/MethodName:\n";
      data << "  EnforcedStyle: snake_case\n";
      data << "Naming/ClassAndModuleCamelCase:\n";
      data << "  Enabled: true\n";
      data << "Style/Lambda:\n";
      data << "  EnforcedStyle: line_count_dependent\n";
      data << "Layout/LineLength:\n";
      data << "  Max: 80\n\n";
    end

    File.write ".rubocop.yml", result;
  end

  private def write_rspec_config
    puts "  #{ARROW} .rspec";

    result = String.build do |data|
      data << "--format documentation\n";
      data << "--color\n";
    end

    File.write ".rspec", result;
  end

  private def write_agents_file
    puts "  #{ARROW} AGENTS.md";

    result = String.build do |data|
      write_agents_common data;

      data << "## 5. Project Context\n\n";

      data << "### Stack\n\n";

      data << "- Ruby project managed by Emeralds (`em` CLI) on top of Bundler.\n";
      data << "- `Gemfile` is the source of truth for dependencies.\n";
      data << "- `em.json` wraps it and delegates to `bundler`/`ruby`.\n\n";

      data << "### Commands\n\n";

      data << "- `em help` - get information about all commands. use this to navigate.\n\n";

      data << "- Examples:\n";
      data << "  - `em build app debug` — run the application.\n";
      data << "  - `em test` — run tests.\n";
      data << "  - `em install` — fetch dependencies via `bundle install`.\n";
      data << "  - `em add <name>` — scaffold a new module (source + spec).\n\n";

      data << "### Layout\n\n";

      data << "- `src/` — source files (`.rb`).\n";
      data << "- `spec/` — spec files (`*_spec.rb`).\n";
      data << "- `lib/` — vendored gems (gitignored).\n";
      data << "- `bin/` — executables (gitignored).\n";
      data << "- `Gemfile` — dependencies.\n";
      data << "- `em.json` — Emeralds wrapper configuration.\n\n";

      data << "### Code Style\n\n";

      data << "- Run `em lint` to format and lint sources using RuboCop.\n";
      data << "- Prefer the standard library over adding dependencies.\n";
      data << "- 2-space indent, final newline, LF, trimmed trailing whitespace.\n";
      data << "- Max 80 chars/line. Follow existing script style.\n";
      data << "- **Always end statements with semicolons.** Non-negotiable.\n";
      data << "- Double quotes; `snake_case` funcs with keyword params returning\n";
      data << "  hashes; `PascalCase` classes.\n";
      data << "- Single-statement lambdas: `->`; multi: `do...end`.\n";
      data << "- Add focused tests for real behavior changes when practical.\n\n";

      data << "### Testing\n\n";

      data << "- Framework: RSpec.\n";
      data << "- Spec files live in `spec/` and end in `_spec.rb`.\n";
      data << "- Run with `em test` (uses `bundle exec rspec`).\n";
      data << "- Spec entry point is `spec/spec_helper.rb`.\n";
    end

    File.write "AGENTS.md", result;
  end

  def write_language_files
    write_em_json;
    write_gitignore_file;
    write_spec_files;
    write_source_files;
    write_gemfile;
    write_rubocop_yml;
    write_rspec_config;
    write_agents_file;
  end
end
