class Emeralds::C::Init < Emeralds::Init
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
        "directories" => ["libs", ".opencode", ".claude"],
      },
      "lintignore" => {
        "extensions"  => [] of String,
        "directories" => ["libs"],
      },
      "scripts"       => {} of String => String,
      "compile-flags" => {
        "darwin" => {
          "debug"   => ["clang", "-O2", "-std=c89", "-g", "-fsanitize=address", "-Wall", "-Wextra", "-Werror", "-pedantic", "-pedantic-errors", "-Wpedantic"],
          "release" => ["clang", "-O2", "-std=c89"],
        },
        "linux" => {
          "debug"   => ["gcc", "-O2", "-std=c89", "-g", "-Wall", "-Wextra", "-Werror", "-pedantic", "-pedantic-errors", "-Wpedantic"],
          "release" => ["gcc", "-O2", "-std=c89"],
        },
        "win32" => {
          "debug"   => ["gcc", "-O2", "-std=c89", "-g", "-Wall", "-Wextra", "-Werror", "-pedantic", "-pedantic-errors", "-Wpedantic"],
          "release" => ["gcc", "-O2", "-std=c89"],
        },
      },
      "link"             => [] of String,
      "dependencies"     => {} of String => String,
      "dev-dependencies" => {
        "https://github.com/Oblivious-Oblivious/cSpec" => "latest",
      },
    }.to_pretty_json + "\n";
  end

  private def create_src_header
    puts "    #{ARROW} #{@name}.h";

    result = String.build do |data|
      data << "#ifndef __#{@name.to_c_identifier.upcase}_H_\n";
      data << "#define __#{@name.to_c_identifier.upcase}_H_\n\n";

      data << "#include \"get-value/get-value.h\"\n\n";

      data << "#endif\n";
    end

    File.write (File.join "src", "#{@name}.h"), result;
  end

  private def create_src_main
    puts "    #{ARROW} #{@name}.c";

    result = String.build do |data|
      data << "#include \"#{@name}.h\"\n\n";

      data << "#include <stdio.h>\n\n";

      data << "int main(void) {\n";
      data << "  printf(\"%s\\n\", get_value());\n";
      data << "  return 0;\n";
      data << "}\n";
    end

    File.write (File.join "src", "#{@name}.c"), result;
  end

  private def write_source_files
    puts "  #{ARROW} src";
    Terminal.mkdir "src";
    puts "    #{ARROW} get-value";
    puts "      #{ARROW} get-value.c";
    puts "      #{ARROW} get-value.h";
    create_src_header;
    create_src_main;
    C::Add.new(name: "get-value", silent: true).block.call;
  end

  private def create_spec_main
    puts "    #{ARROW} #{@name}.spec.c";

    result = String.build do |data|
      data << "#include \"../libs/cSpec/export/cSpec.h\"\n\n";

      data << "int main(void) {\n";
      data << "  cspec_run_suite(\"all\", {});\n";
      data << "}\n";
    end

    File.write (File.join "spec", "#{@name}.spec.c"), result;
  end

  private def write_spec_files
    puts "  #{ARROW} spec";
    Terminal.mkdir "spec";
    puts "    #{ARROW} get-value";
    puts "      #{ARROW} get-value.module.spec.h";
    create_spec_main;
  end

  private def write_clangd
    puts "  #{ARROW} .clangd";

    result = String.build do |data|
      data << "CompileFlags:\n";
      data << "  Add:\n";
      data << "    - \"-xc\"\n";
      data << "    - \"-std=c23\"\n\n";

      data << "Diagnostics:\n";
      data << "  Suppress: [unused-includes, hicpp-use-nullptr]\n";
    end

    File.write ".clangd", result;
  end

  private def write_clang_format
    puts "  #{ARROW} .clang-format";

    result = String.build do |data|
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

    File.write ".clang-format", result;
  end

  private def write_clang_tidy
    puts "  #{ARROW} .clang-tidy";

    result = String.build do |data|
      data << "---\n";
      data << "Checks:\n";
      data << "  - '*'\n";
      data << "  - '-altera-unroll-loops'\n";
      data << "  - '-bugprone-multi-level-implicit-pointer-conversion'\n";
      data << "  - '-bugprone-reserved-identifier'\n";
      data << "  - '-cert-dcl37-c'\n";
      data << "  - '-cert-dcl51-cpp'\n";
      data << "  - '-llvm-header-guard'\n";
      data << "  - '-llvmlibc-restrict-system-libc-headers'\n";
      data << "  - '-misc-include-cleaner'\n";
      data << "  - '-modernize-use-nullptr'\n";
      data << "  - '-readability-function-cognitive-complexity'\n";
      data << "  - '-readability-identifier-length'\n";
    end

    File.write ".clang-tidy", result;
  end

  private def write_gitignore_file
    puts "  #{ARROW} .gitignore";

    result = String.build do |data|
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

      data << "# AI\n";
      data << ".claude\n";
      data << ".opencode\n\n";

      data << "libs/\n";
    end

    File.write ".gitignore", result;
  end

  private def write_gitattributes_file
    puts "  #{ARROW} .gitattributes";

    result = String.build do |data|
      data << "# Auto detect text files and perform LF normalization\n";
      data << "* text=auto\n\n";

      data << "*.h linguist-language=C\n";
      data << "*.c linguist-language=C\n";
    end

    File.write ".gitattributes", result;
  end

  private def write_agents_file
    puts "  #{ARROW} AGENTS.md";

    result = String.build do |data|
      write_agents_common data;

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

    File.write "AGENTS.md", result;
  end

  def write_language_files
    write_em_json;
    write_clang_format;
    write_clang_tidy;
    write_clangd;
    write_gitattributes_file;
    write_gitignore_file;
    write_spec_files;
    write_source_files;
    write_agents_file;
  end
end
