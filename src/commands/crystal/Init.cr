class Emeralds::Crystal::Init < Emeralds::Init
  private def module_name
    @name.split(/[\s\/_-]+/).reject(&.empty?).map(&.capitalize).join;
  end

  private def write_shard_yml
    puts "  #{ARROW} shard.yml";

    result = String.build do |data|
      data << "name: #{@name}\n";
      data << "version: 0.0.1\n\n";

      data << "authors:\n";
      data << "  - #{Options.author}\n\n";

      data << "targets:\n";
      data << "  #{@name}:\n";
      data << "    main: src/#{@name}.cr\n";
      data << "  ameba:\n";
      data << "    main: lib/ameba/bin/ameba.cr\n\n";

      data << "crystal: \">= 1.0.0\"\n\n";

      data << "license: MIT\n\n";

      data << "dependencies:\n\n";

      data << "development_dependencies:\n";
      data << "  ameba:\n";
      data << "    github: crystal-ameba/ameba\n\n";
    end

    File.write "shard.yml", result;
  end

  private def write_em_json
    puts "  #{ARROW} em.json";

    result = String.build do |data|
      data << "{\n";
      data << "  \"$schema\": \"https://raw.githubusercontent.com/Oblivious-Oblivious/Emeralds/master/schema/em.schema.json\",\n";
      data << "  \"author\": \"#{Options.author}\",\n";
      data << "  \"name\": \"#{@name}\",\n";
      data << "  \"template\": \"#{Options.template}\",\n";
      data << "  \"version\": \"0.0.1\",\n";
      data << "  \"license\": \"mit\",\n";
      data << "  \"locignore\": {\n";
      data << "    \"extensions\": [],\n";
      data << "    \"directories\": [\"lib\"]\n";
      data << "  },\n";
      data << "  \"lintignore\": {\n";
      data << "    \"extensions\": [],\n";
      data << "    \"directories\": [\"lib\"]\n";
      data << "  },\n";
      data << "  \"scripts\": {\n";
      data << "    \"shards\": \"shards\",\n";
      data << "    \"docs\": \"crystal docs src/*.cr\",\n";
      data << "    \"ameba\": \"shards build ameba -Dpreview_mt\"\n";
      data << "  },\n";
      data << "  \"compile-flags\": {\n";
      data << "    \"darwin\": {\n";
      data << "      \"debug\": [\"shards\", \"build\"],\n";
      data << "      \"release\": [\"shards\", \"build\", \"-Dpreview_mt\", \"--release\", \"--no-debug\"]\n";
      data << "    },\n";
      data << "    \"linux\": {\n";
      data << "      \"debug\": [\"shards\", \"build\"],\n";
      data << "      \"release\": [\"shards\", \"build\", \"-Dpreview_mt\", \"--release\", \"--no-debug\"]\n";
      data << "    },\n";
      data << "    \"win32\": {\n";
      data << "      \"debug\": [\"shards\", \"build\"],\n";
      data << "      \"release\": [\"shards\", \"build\", \"-Dpreview_mt\", \"--release\", \"--no-debug\"]\n";
      data << "    }\n";
      data << "  },\n";
      data << "  \"dependencies\": {},\n";
      data << "  \"dev-dependencies\": {}\n";
      data << "}\n";
    end

    File.write "em.json", result;
  end

  private def create_src_main
    puts "    #{ARROW} #{@name}.cr";

    result = String.build do |data|
      data << "require \"./#{@name}.libs\";\n\n";

      data << "puts #{module_name}::GetValue.new.value;\n";
    end

    File.write (File.join "src", "#{@name}.cr"), result;
  end

  private def create_libs_main
    puts "    #{ARROW} #{@name}.libs.cr";

    result = String.build do |data|
      data << "require \"./get-value/get-value\";\n";
    end

    File.write (File.join "src", "#{@name}.libs.cr"), result;
  end

  private def write_source_files
    puts "  #{ARROW} src";
    Terminal.mkdir "src";
    puts "    #{ARROW} get-value";
    puts "      #{ARROW} get-value.cr";
    create_src_main;
    create_libs_main;
    Crystal::Add.new(name: "get-value", silent: true).block.call;
  end

  private def create_spec_main
    puts "    #{ARROW} #{@name}.spec.cr";

    result = String.build do |data|
      data << "require \"spec\";\n";
      data << "require \"../src/#{@name}.libs\";\n\n";

      data << "require \"./get-value/get-value.spec\";\n";
    end

    File.write (File.join "spec", "#{@name}.spec.cr"), result;
  end

  private def write_spec_files
    puts "  #{ARROW} spec";
    Terminal.mkdir "spec";
    puts "    #{ARROW} get-value";
    puts "      #{ARROW} get-value.spec.cr";
    create_spec_main;
  end

  private def write_gitignore_file
    puts "  #{ARROW} .gitignore";

    result = String.build do |data|
      data << "/docs/\n";
      data << "/lib/\n";
      data << "/bin/\n";
      data << "/.shards/\n";
      data << "*.dwarf\n\n";

      data << "# Linux\n";
      data << "fix_linux\n\n";

      data << "# MacOS\n";
      data << ".DS_Store\n\n";

      data << "# AI\n";
      data << ".claude\n";
      data << ".opencode\n";
    end

    File.write ".gitignore", result;
  end

  private def write_agents_file
    puts "  #{ARROW} AGENTS.md";

    result = String.build do |data|
      write_agents_common data;

      data << "## 5. Project Context\n\n";

      data << "### Stack\n\n";

      data << "- Crystal project managed by Emeralds (`em` CLI) on top of Shards.\n";
      data << "- `shard.yml` is the source of truth for targets and dependencies.\n";
      data << "- `em.json` wraps it and delegates to `shards`/`crystal`.\n\n";

      data << "### Commands\n\n";

      data << "- `em help` - get information about all commands. use this to navigate.\n\n";

      data << "- Examples:\n";
      data << "  - `em build [app | lib] [debug | release]` — build the project.\n";
      data << "  - `em test` — run tests.\n";
      data << "  - `em install` — fetch dependencies into `lib/`.\n";
      data << "  - `em add <name>` — scaffold a new module (source + spec).\n\n";

      data << "### Layout\n\n";

      data << "- `src/` — source files (`.cr`).\n";
      data << "- `spec/` — spec files (`*.spec.cr`).\n";
      data << "- `lib/` — installed shards (gitignored).\n";
      data << "- `bin/` — compiled binaries (gitignored).\n";
      data << "- `shard.yml` — targets and dependencies.\n";
      data << "- `em.json` — Emeralds wrapper configuration.\n\n";

      data << "### Code Style\n\n";

      data << "- Run `em lint` to format and lint documents using ameba.\n";
      data << "- Prefer the standard library over adding dependencies.\n";
      data << "- Keep Crystal code style local: 2-space indent, final newline, LF,\n";
      data << "  trimmed trailing whitespace.\n";
      data << "- Max 80 chars/line. Follow existing script style.\n";
      data << "- Crystal statements end with semicolons. Match surrounding files.\n";
      data << "- Add focused tests for real behavior changes when practical.\n";
      data << "- Single-statement lambdas: `->`; multi: `do...end`.\n\n";

      data << "### Testing\n\n";

      data << "- Framework: Crystal's built-in `spec`.\n";
      data << "- Spec files live in `spec/` and end in `.spec.cr`.\n";
      data << "- Run with `em test` (uses `crystal spec`).\n\n";

      data << "### Running Tests\n\n";

      data << "- `em test` wraps `crystal spec`.\n";
      data << "- `crystal spec` runs everything under `spec/`.\n";
      data << "- `crystal spec spec/foo_spec.cr` runs a single file.\n";
      data << "- `crystal spec -e \"pattern\"` / `--tag focus` to filter examples.\n";
    end

    File.write "AGENTS.md", result;
  end

  private def write_ameba_yml
    puts "  #{ARROW} .ameba.yml";

    result = String.build do |data|
      data << "Lint/Formatting:\n";
      data << "  Enabled: false\n";
      data << "Lint/SpecFilename:\n";
      data << "  Enabled: false\n";
      data << "Naming/Filename:\n";
      data << "  Enabled: false\n";
    end

    File.write ".ameba.yml", result;
  end

  def write_language_files
    write_em_json;
    write_gitignore_file;
    write_spec_files;
    write_source_files;
    write_shard_yml;
    write_ameba_yml;
    write_agents_file;
  end
end
