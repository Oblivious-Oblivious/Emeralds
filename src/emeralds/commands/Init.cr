class Emeralds::Init < Emeralds::Command
  private def create_lib_directory
    if File.exists? ARGV[1]
      puts "An emerald with name: #{ARGV[1]} already exists".colorize(:red);
      exit 0;
    elsif (validate_filename ARGV[1])
      puts "#{COG} Creating directory: #{ARGV[1].colorize(:green).mode(:bold)}";
      Terminal.mkdir ARGV[1];
    else
      puts "Cannot create a new emerald with name: #{ARGV[1]}.".colorize(:red);
      exit 0;
    end
  end

  private def write_em_file
    puts "  #{ARROW} em.json";

    data = String.build do |data|
      data << "{\n";
      data << "  \"name\": \"#{ARGV[1]}\",\n\n";

      data << "  \"version\": \"0.1.0\",\n\n";

      data << "  \"dependencies\": {},\n\n";

      data << "  \"dev-dependencies\": {\n";
      data << "    \"cSpec\": \"Oblivious-Oblivious/cSpec\"\n";
      data << "  },\n\n";

      data << "  \"build\": \"\",\n\n";

      data << "  \"compile-flags\": {\n";
      data << "    \"cc\": \"clang\",\n";
      data << "    \"debug\": {\n";
      data << "      \"opt\": \"-Og\",\n";
      data << "      \"version\": \"-std=c89\",\n";
      data << "      \"flags\": \"-g -fsanitize=address\",\n";
      data << "      \"warnings\": \"-Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic\"\n";
      data << "    },\n";
      data << "    \"release\": {\n";
      data << "      \"opt\": \"-O2\",\n";
      data << "      \"version\": \"-std=c89\",\n";
      data << "      \"flags\": \"\",\n";
      data << "      \"warnings\": \"\"\n";
      data << "    }\n";
      data << "  },\n\n";

      data << "  \"license\": \"mit\"\n";
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
      data << "#Prerequisites\n";
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

      data << "libs/\n";
    end

    File.write ".gitignore", data;
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
      data << "# #{ARGV[1]}\n\n";

      data << "TODO: Write a description here\n\n";

      data << "# Installation\n\n";

      data << "TODO: Write installation instructions here\n\n";

      data << "## Usage\n\n";

      data << "TODO: Write usage instructions here\n\n";

      data << "## Development\n\n";

      data << "TODO: Write development instructions here\n\n";

      data << "## Contributing\n\n";

      data << "1. Fork it (<https://github.com/your-github-user/#{ARGV[1]}/fork>)\n";
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

  private def create_src_main
    puts "    #{ARROW} #{ARGV[1]}.c";

    data = String.build do |data|
      data << "#include \"get_value/get_value.h\"\n\n";

      data << "#include <stdio.h>\n\n";

      data << "int main(void) {\n";
      data << "  printf(\"%s\\n\", get_value());\n";
      data << "  return 0;\n";
      data << "}\n";
    end

    File.write (File.join "src", "#{ARGV[1]}.c"), data;
  end

  private def create_source_files
    puts "  #{ARROW} src";
    Terminal.mkdir "src";
    puts "    #{ARROW} get_value";
    puts "      #{ARROW} get_value.c";
    puts "      #{ARROW} get_value.h";
    create_src_main;
    Terminal.generic_cmd "em add get_value";
  end

  private def create_spec_main
    puts "    #{ARROW} #{ARGV[1]}.spec.c";

    data = String.build do |data|
      data << "#include \"../libs/cSpec/export/cSpec.h\"\n";
      data << "#include \"get_value/get_value.module.spec.h\"\n\n";

      data << "int main(void) {\n";
      data << "  cspec_run_suite(\"all\", { T_get_value(); });\n";
      data << "}\n";
    end

    File.write (File.join "spec", "#{ARGV[1]}.spec.c"), data;
  end

  private def create_spec_files
    puts "  #{ARROW} spec";
    Terminal.mkdir "spec";
    puts "    #{ARROW} get_value";
    puts "      #{ARROW} get_value.module.spec.h";
    create_spec_main;
  end

  def message
    "Emeralds - Initializing a new project";
  end

  def block
    -> {
      create_lib_directory;
      Dir.cd ARGV[1];
      puts "#{COG} Writing initial files:";

      write_em_file;
      initialize_git_directory;
      create_spec_files;
      create_source_files;
      create_clangd;
      create_clang_format;
      write_gitignore_file;
      wget_license;
      generate_readme;
      Dir.cd "..";
    };
  end
end
