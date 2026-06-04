class Emeralds::Init < Emeralds::Command
  private def create_lib_directory
    if File.exists? @name
      puts "An emerald with name: #{@name} already exists".colorize(:red);
      exit 0;
    else
      puts "#{COG} Creating directory: #{@name.colorize(:green).mode(:bold)}";
      Terminal.mkdir @name;
    end
  end

  private def write_em_file
    puts "  #{ARROW} em.json";

    data = String.build do |data|
      data << "{\n";
      data << "  \"$schema\": \"https://raw.githubusercontent.com/Oblivious-Oblivious/Emeralds/master/schema/em.schema.json\",\n";
      data << "  \"author\": \"#{Options.author}\",\n";
      data << "  \"name\": \"#{@name}\",\n";
      data << "  \"version\": \"0.0.1\",\n";
      data << "  \"license\": \"mit\",\n";
      data << "  \"locignore\": {\n";
      data << "    \"extensions\": [],\n";
      data << "    \"directories\": [\"libs\"]\n";
      data << "  },\n";
      data << "  \"lintignore\": {\n";
      data << "    \"extensions\": [],\n";
      data << "    \"directories\": [\"libs\"]\n";
      data << "  },\n";
      data << "  \"scripts\": {},\n";
      data << "  \"compile-flags\": {\n";
      data << "    \"darwin\": {\n";
      data << "      \"debug\": [\"clang\", \"-O2\", \"-std=c89\", \"-g\", \"-fsanitize=address\", \"-Wall\", \"-Wextra\", \"-Werror\", \"-pedantic\", \"-pedantic-errors\", \"-Wpedantic\"],\n";
      data << "      \"release\": [\"clang\", \"-O2\", \"-std=c89\"]\n";
      data << "    },\n";
      data << "    \"linux\": {\n";
      data << "      \"debug\": [\"gcc\", \"-O2\", \"-std=c89\", \"-g\", \"-Wall\", \"-Wextra\", \"-Werror\", \"-pedantic\", \"-pedantic-errors\", \"-Wpedantic\"],\n";
      data << "      \"release\": [\"gcc\", \"-O2\", \"-std=c89\"]\n";
      data << "    },\n";
      data << "    \"win32\": {\n";
      data << "      \"debug\": [\"gcc\", \"-O2\", \"-std=c89\", \"-g\", \"-Wall\", \"-Wextra\", \"-Werror\", \"-pedantic\", \"-pedantic-errors\", \"-Wpedantic\"],\n";
      data << "      \"release\": [\"gcc\", \"-O2\", \"-std=c89\"]\n";
      data << "    }\n";
      data << "  },\n";
      data << "  \"dependencies\": {},\n";
      data << "  \"dev-dependencies\": {\n";
      data << "    \"https://github.com/Oblivious-Oblivious/cSpec\": \"latest\"\n";
      data << "  }\n";
      data << "}\n";
    end

    File.write "em.json", data;
  end

  private def initialize_git_directory
    puts "  #{ARROW} .git";
    Terminal.git_init;
  end

  private def write_gitignore_file
    puts "  #{ARROW} .gitignore";

    data = String.build do |data|
      data << "# Prerequisites\n";
      data << "*.d\n\n";

      data << "# Object files\n";
      data << "*.o\n";
      data << "*.ko\n";
      data << "*.obj\n";
      data << "*.elf\n\n";

      data << "# Linker output\n";
      data << "*.ilk\n";
      data << "*.map\n";
      data << "*.exp\n\n";

      data << "# Precompiled Headers\n";
      data << "*.gch\n";
      data << "*.pch\n\n";

      data << "# Executables\n";
      data << "*.exe\n";
      data << "*.out\n";
      data << "*.app\n";
      data << "*.i*86\n";
      data << "*.x86_64\n";
      data << "*.hex\n\n";

      data << "# Debug files\n";
      data << "*.dSYM/\n";
      data << "*.su\n";
      data << "*.idb\n";
      data << "*.pdb\n\n";

      data << "# Kernel Module Compile Results\n";
      data << "# *.mod*\n";
      data << "*.cmd\n";
      data << ".tmp_versions/\n";
      data << "modules.order\n";
      data << "Module.symvers\n";
      data << "Mkfile.old\n";
      data << "dkms.conf\n\n";

      data << "# MacOS\n";
      data << ".DS_Store\n\n";

      data << "libs/\n";
    end

    File.write ".gitignore", data;
  end

  private def write_gitattributes_file
    puts "  #{ARROW} .gitattributes";

    data = String.build do |data|
      data << "# Auto detect text files and perform LF normalization\n";
      data << "* text=auto\n\n";

      data << "*.h linguist-language=C\n";
      data << "*.c linguist-language=C\n";
    end

    File.write ".gitattributes", data;
  end

  private def create_clangd
    puts "  #{ARROW} .clangd";

    data = String.build do |data|
      data << "CompileFlags:\n";
      data << "  Add:\n";
      data << "    - \"-xc\"\n";
      data << "    - \"-std=c2x\"\n\n";

      data << "Diagnostics:\n";
      data << "  Suppress: unused-includes\n";
    end

    File.write ".clangd", data;
  end

  private def create_clang_format
    puts "  #{ARROW} .clang-format";

    data = String.build do |data|
      data << "---\n";
      data << "BasedOnStyle: LLVM\n\n";

      data << "AlignAfterOpenBracket: BlockIndent\n";
      data << "AlignConsecutiveAssignments:\n";
      data << "  Enabled: true\n";
      data << "  AcrossComments: true\n";
      data << "AlignConsecutiveMacros:\n";
      data << "  Enabled: true\n";
      data << "  AcrossComments: true\n";
      data << "AlignConsecutiveBitFields:\n";
      data << "  Enabled: true\n";
      data << "  AcrossComments: true\n";
      data << "AlignConsecutiveShortCaseStatements:\n";
      data << "  Enabled: true\n";
      data << "  AcrossEmptyLines: true\n";
      data << "  AcrossComments: true\n";
      data << "AlignEscapedNewlines: Left\n";
      data << "AllowShortBlocksOnASingleLine: Empty\n";
      data << "BinPackArguments: false\n";
      data << "BinPackParameters: false\n";
      data << "BitFieldColonSpacing: After\n";
      data << "BreakArrays: true\n";
      data << "BreakStringLiterals: true\n";
      data << "ColumnLimit: 80\n";
      data << "ContinuationIndentWidth: 2\n";
      data << "IncludeBlocks: Regroup\n";
      data << "IndentExternBlock: Indent\n";
      data << "IndentGotoLabels: true\n";
      data << "IndentPPDirectives: BeforeHash\n";
      data << "IndentWidth: 2\n";
      data << "InsertBraces: true\n";
      data << "InsertNewlineAtEOF: true\n";
      data << "MacroBlockBegin: \"va_start\"\n";
      data << "MacroBlockEnd: \"va_end\"\n";
      data << "MaxEmptyLinesToKeep: 3\n";
      data << "PointerAlignment: Right\n";
      data << "QualifierAlignment: Left\n";
      data << "ReferenceAlignment: Right\n";
      data << "ReflowComments: true\n";
      data << "RemoveSemicolon: true\n";
      data << "SortIncludes: CaseInsensitive\n";
      data << "SpaceAfterCStyleCast: false\n";
      data << "SpaceAfterLogicalNot: false\n";
      data << "SpaceBeforeParens: false\n";
      data << "SpacesInContainerLiterals: false\n";
      data << "SpacesInParens: Never\n";
    end

    File.write ".clang-format", data;
  end

  private def generate_readme
    puts "  #{ARROW} README.md";

    data = String.build do |data|
      data << "# #{@name}\n\n";

      data << "[![MIT License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)\n\n";

      data << "TODO: Write a description here\n\n";

      data << "# Installation\n\n";

      data << "TODO: Write installation instructions here\n\n";

      data << "## Usage\n\n";

      data << "TODO: Write usage instructions here\n\n";

      data << "## Development\n\n";

      data << "TODO: Write development instructions here\n\n";

      data << "## Contributing\n\n";

      data << "1. Fork it (<https://github.com/your-github-user/#{@name}/fork>)\n";
      data << "2. Create your feature branch (`git checkout -b my-new-feature`)\n";
      data << "3. Commit your changes (`git commit -am 'Add some feature'`)\n";
      data << "4. Push to the branch (`git push origin my-new-feature`)\n";
      data << "5. Create a new Pull Request\n\n";

      data << "## Contributors\n\n";

      data << "- [YourName](https://github.com/your-github-user) - creator and maintainer\n";
      data << "";
    end

    File.write "README.md", data;
  end

  private def app_name_upcase
    @name.gsub(/[\s-]+/, "_").upcase;
  end

  private def create_src_header
    puts "    #{ARROW} #{@name}.h";

    data = String.build do |data|
      data << "#ifndef __#{app_name_upcase}_H_\n";
      data << "#define __#{app_name_upcase}_H_\n\n";

      data << "#include \"get_value/get_value.h\"\n\n";

      data << "#endif\n";
    end

    File.write (File.join "src", "#{@name}.h"), data;
  end

  private def create_src_main
    puts "    #{ARROW} #{@name}.c";

    data = String.build do |data|
      data << "#include \"#{@name}.h\"\n\n";

      data << "#include <stdio.h>\n\n";

      data << "int main(void) {\n";
      data << "  printf(\"%s\\n\", get_value());\n";
      data << "  return 0;\n";
      data << "}\n";
    end

    File.write (File.join "src", "#{@name}.c"), data;
  end

  private def create_source_files
    puts "  #{ARROW} src";
    Terminal.mkdir "src";
    puts "    #{ARROW} get_value";
    puts "      #{ARROW} get_value.c";
    puts "      #{ARROW} get_value.h";
    create_src_header;
    create_src_main;
    Add.new(name: "get_value", silent: true).block.call;
  end

  private def create_spec_main
    puts "    #{ARROW} #{@name}.spec.c";

    data = String.build do |data|
      data << "#include \"../libs/cSpec/export/cSpec.h\"\n\n";

      data << "int main(void) {\n";
      data << "  cspec_run_suite(\"all\", {});\n";
      data << "}\n";
    end

    File.write (File.join "spec", "#{@name}.spec.c"), data;
  end

  private def create_spec_files
    puts "  #{ARROW} spec";
    Terminal.mkdir "spec";
    puts "    #{ARROW} get_value";
    puts "      #{ARROW} get_value.module.spec.h";
    create_spec_main;
  end

  private def write_agents_file
    puts "  #{ARROW} AGENTS.md";

    data = String.build do |data|
      data << "# AGENTS.md\n\n";

      data << "Behavioral guidelines to reduce common LLM coding mistakes. Merge with\n";
      data << "project-specific instructions as needed.\n\n";

      data << "**Tradeoff:** These guidelines bias toward caution over speed. For trivial\n";
      data << "tasks, use judgment.\n\n";

      data << "## 0. Non-negotiables\n\n";

      data << "These override everything else:\n\n";

      data << "1. **No flattery, no filler.** Start with the answer or action.\n";
      data << "2. **Disagree when you disagree.** Never agree with false premises to be polite.\n";
      data << "3. **Never fabricate.** If you don't know, read the file, run the command, or\n";
      data << "   say so.\n";
      data << "4. **Touch only what you must.** Every changed line must trace to the user's\n";
      data << "   request.\n\n";

      data << "## 1. Think Before Coding\n\n";

      data << "**Don't assume. Don't hide confusion. Surface tradeoffs.**\n\n";

      data << "Before implementing:\n\n";

      data << "- State your assumptions explicitly. If uncertain, ask.\n";
      data << "- If multiple interpretations exist, present them - don't pick silently.\n";
      data << "- If a simpler approach exists, say so. Push back when warranted.\n";
      data << "- If something is unclear, stop. Name what's confusing. Ask.\n\n";

      data << "## 2. Simplicity First\n\n";

      data << "**Minimum code that solves the problem. Nothing speculative.**\n\n";

      data << "- No features beyond what was asked.\n";
      data << "- No abstractions for single-use code.\n";
      data << "- No \"flexibility\" or \"configurability\" that wasn't requested.\n";
      data << "- No error handling for impossible scenarios.\n";
      data << "- If you write 200 lines and it could be 50, rewrite it.\n";
      data << "- If you write 20 lines and it be 5, rewrite it.\n\n";

      data << "Ask yourself: \"Would a senior engineer say this is overcomplicated?\" If yes,\n";
      data << "simplify.\n\n";

      data << "## 3. Surgical Changes\n\n";

      data << "**Touch only what you must. Clean up only your own mess.**\n\n";

      data << "When editing existing code:\n\n";

      data << "- Don't \"improve\" adjacent code, comments, or formatting.\n";
      data << "- Don't refactor things that aren't broken.\n";
      data << "- Match existing style, even if you'd do it differently.\n";
      data << "- If you notice unrelated dead code, mention it - don't delete it.\n\n";

      data << "When your changes create orphans:\n\n";

      data << "- Remove imports/variables/functions that YOUR changes made unused.\n";
      data << "- Don't remove pre-existing dead code unless asked.\n\n";

      data << "The test: Every changed line should trace directly to the user's request.\n\n";

      data << "## 4. Goal-Driven Execution\n\n";

      data << "**Define success criteria. Loop until verified.**\n\n";

      data << "Transform tasks into verifiable goals:\n\n";

      data << "- \"Add validation\" → \"Write tests for invalid inputs, then make them pass\"\n";
      data << "- \"Fix the bug\" → \"Write a test that reproduces it, then make it pass\"\n";
      data << "- \"Refactor X\" → \"Ensure tests pass before and after\"\n\n";

      data << "For multi-step tasks, state a brief plan:\n\n";

      data << "```\n";
      data << "1. [Step] → verify: [check]\n";
      data << "2. [Step] → verify: [check]\n";
      data << "3. [Step] → verify: [check]\n";
      data << "```\n\n";

      data << "Strong success criteria let you loop independently. Weak criteria (\"make it\n";
      data << "work\") require constant clarification.\n\n";

      data << "---\n\n";

      data << "**These guidelines are working if:** fewer unnecessary changes in diffs, fewer\n";
      data << "rewrites due to overcomplication, and clarifying questions come before\n";
      data << "implementation rather than after mistakes.\n\n";

      data << "## 5. Project Context\n\n";

      data << "### Stack\n\n";

      data << "- C project managed by Emeralds (`em` CLI).\n";
      data << "- Compiler config comes from `em.json`.\n\n";

      data << "### Commands\n\n";

      data << "- `em help` - get information about all commands. use this to navigate.\n\n";

      data << "- Examples:\n";
      data << "  - `em build [app | lib] [debug | release]` — build the project.\n";
      data << "  - `em test` — run tests.\n";
      data << "  - `em install` — fetch dependencies into `libs/`.\n";
      data << "  - `em add <name>` — scaffold a new module (source + header).\n\n";

      data << "### Layout\n\n";

      data << "- `src/` — source modules (`.c` and `.h` files).\n";
      data << "- `spec/` — cSpec test files.\n";
      data << "- `libs/` — installed dependencies (gitignored).\n";
      data << "- `export/` — dependency public headers.\n";
      data << "- `em.json` — project configuration (single source of truth).\n\n";

      data << "### Config Format\n\n";

      data << "- Compile flags per platform: `compile-flags.darwin` / `linux` / `win32`.\n";
      data << "- Each platform has `debug` and `release` profiles.\n";
      data << "- Production dependencies: `dependencies`.\n";
      data << "- Development dependencies: `dev-dependencies`.\n\n";

      data << "### Testing\n\n";

      data << "- Framework: cSpec.\n";
      data << "- Spec files live in `spec/`.\n";
      data << "- Include path: `libs/cSpec/export/cSpec.h`.\n";
      data << "- Suite runner pattern: `cspec_run_suite(...)`.\n\n";

      data << "### Code Style\n\n";

      data << "- Favor C89 compatibility by default; only use newer C features when\n";
      data << "  explicitly told to.\n";
      data << "- `.clang-format` is authoritative. Don't override it.\n";
      data << "- `.clangd` provides editor intelligence.\n\n";

      data << "# cSpec — Usage Reference\n\n";

      data << "Single-header, C89, compile-time TDD/BDD unit testing (RSpec-style). No linking,\n";
      data << "no runtime deps — just `#include \"libs/cSpec/export/cSpec.h\"`.\n\n";

      data << "Convention: one module per `<name>.module.spec.h`, plus one `*.spec.c` runner\n";
      data << "that includes them. Build/run with `em test`.\n\n";

      data << "## Example\n\n";

      data << "```c\n";
      data << "/* stack.module.spec.h */\n";
      data << "#include \"../src/cSpec.h\"\n\n";

      data << "module(T_stack, {              /* defines void T_stack(void) */\n";
      data << "  before_each(&setup);         /* void(void) ptr, runs around every `it` */\n";
      data << "  after_each(&defer);\n\n";

      data << "  describe(\"stack\", {\n";
      data << "    int x;\n";
      data << "    before({ x = 99; });       /* inlined ONCE here, not per-test */\n\n";

      data << "    it(\"pops what it pushed\", {\n";
      data << "      push(s, x);\n";
      data << "      assert_that_int(pop(s) equals to x);\n";
      data << "    });\n\n";

      data << "    after({ /* one-time teardown */ });\n";
      data << "  });\n";
      data << "})\n\n";

      data << "/* runner.spec.c */\n";
      data << "int main(void) {\n";
      data << "  cspec_run_suite(\"all\", {     /* \"all\" | \"passing\" | \"failing\" | \"skipped\" */\n";
      data << "    T_stack();                 /* call each module */\n";
      data << "  });\n";
      data << "}\n";
      data << "```\n\n";

      data << "`cspec_run_suite(type, {...})`: all tests run; `type` only filters what prints.\n\n";

      data << "## Structure\n\n";

      data << "- `module(name, {...})` — top-level container; defines callable `name`.\n";
      data << "- `describe(\"text\", {...})` / `context(...)` — groups (aliases); nest freely.\n";
      data << "- `it(\"text\", {...})` — one test; independent; any failed assert fails it.\n\n";

      data << "## Setup & teardown\n\n";

      data << "- `before({...})` / `after({...})` — inlined **once** where written (block-level).\n";
      data << "- `before_each(&fn)` / `after_each(&fn)` — `void fn(void)` run **around every `it`**.\n\n";

      data << "## Assertions\n\n";

      data << "```c\n";
      data << "assert_that(expr);                  /* fail if false; nassert_that = fail if true */\n";
      data << "assert_that(len is 0);              /* sugar: is -> ==,  isnot -> != */\n";
      data << "fail(\"message\");                    /* always fails */\n\n";

      data << "assert_that_int(got equals to 2);   /* typed equality; nassert_that_int negates */\n";
      data << "assert_that_charptr(s equals to \"\"); /* charptr compares contents */\n";
      data << "assert_that_int_array(got equals to want with array_size 5);\n";
      data << "```\n\n";

      data << "Typed `<type>` suffixes (each has 4 forms: `assert_that_<t>`, `nassert_that_<t>`,\n";
      data << "`..._array`, `nassert..._array`):\n";
      data << "`char`, `unsigned_char`, `short`, `unsigned_short`, `int`, `unsigned_int`,\n";
      data << "`long`, `unsigned_long`, `long_long`, `unsigned_long_long`, `size_t`,\n";
      data << "`ptrdiff_t`, `void_ptr`, `float`, `double`, `long_double`, `charptr`.\n\n";

      data << "Sugar words: `is`=`==`, `isnot`=`!=`, `equals`=`,`, `array_size`=`,`,\n";
      data << "`to`/`with`=nothing. So `assert_that_int(a equals to b)` is `assert_that_int(a, b)`.\n";
      data << "Floats compare within `1E-12`; `void_ptr` compares addresses.\n\n";

      data << "## Skipping\n\n";

      data << "Prefix with `x` to skip (body not run, counts as skipped): `xmodule`,\n";
      data << "`xdescribe`, `xcontext`, `xit`. Shown only under `\"all\"`/`\"skipped\"`.\n\n";

      data << "## Gotchas\n\n";

      data << "- **C89**: declare locals at top of each block; no `//` comments.\n";
      data << "- `describe` state persists across `it`s unless reset in `before`.\n";
      data << "- `before`/`after` are one-time, not per-test — use `before_each`/`after_each`.\n";
      data << "- Runner string must be exactly `all`/`passing`/`failing`/`skipped`, else nothing runs.\n";
      data << "- Failures auto-report `__FILE__:__LINE__`.\n";
    end

    File.write "AGENTS.md", data;
  end

  private def create_agents_symlinks
    puts "  #{ARROW} CLAUDE.md -> AGENTS.md";
    File.symlink "AGENTS.md", "CLAUDE.md";

    puts "  #{ARROW} .cursorrules -> AGENTS.md";
    File.symlink "AGENTS.md", ".cursorrules";

    puts "  #{ARROW} GEMINI.md -> AGENTS.md";
    File.symlink "AGENTS.md", "GEMINI.md";
  end

  def message
    "Emeralds - Initializing a new project";
  end

  def block
    -> {
      create_lib_directory;
      Dir.cd @name do
        puts "#{COG} Writing initial files:";

        write_em_file;
        initialize_git_directory;
        create_spec_files;
        create_source_files;
        create_clangd;
        create_clang_format;
        write_gitignore_file;
        write_gitattributes_file;
        License.new.wget_license;
        generate_readme;
        write_agents_file;
        create_agents_symlinks;
      end
    };
  end
end
