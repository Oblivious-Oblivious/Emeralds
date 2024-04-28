class Emeralds::Init < Emeralds::Command
  # Creates the library directories
  private def create_lib_directory
    puts "#{COG} Creating directory: #{name.colorize(:light_green).mode(:bold)}";
    TerminalHandler.mkdir name;
  end

  # Creates the initial emfile
  private def write_em_file
    puts "  #{ARROW} em.yml";

    data = String.build do |data|
      data << "name: #{name}\n";
      data << "version: 0.1.0\n\n";

      data << "dependencies:\n\n";

      data << "dev-dependencies:\n";
      data << "  cSpec: Oblivious-Oblivious/cSpec\n\n";

      data << "build: #\n\n";

      data << "license: GPLv3\n\n";
    end

    File.write "#{name}/em.yml", data;
  end

  # Creates a new git repository
  private def initialize_git_directory
    puts "  #{ARROW} .git";
    TerminalHandler.generic_cmd "git init #{name}/";
  end

  # Resolves a GPLv3 license from the web
  private def wget_a_gplv3_license
    puts "  #{ARROW} LICENSE";
    TerminalHandler.generic_cmd "wget -O #{name}/LICENSE https://www.gnu.org/licenses/gpl-3.0.txt >/dev/null 2>&1";
  end

  # Creates the .gitignore file
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

    File.write "#{name}/.gitignore", data;
  end

  private def create_clang_format
    puts "  #{ARROW} .clang-format";

    data = String.build do |data|
      data << "---\n";
      data << "BasedOnStyle: LLVM\n\n";

      data << "AlignConsecutiveAssignments:\n\t"
        data << "Enabled: true\n";
        data << "AcrossComments: true\n";
      data << "AlignConsecutiveMacros:\n\t"
        data << "Enabled: true\n";
        data << "AcrossComments: true\n";
      data << "AlignConsecutiveBitFields:\n\t"
        data << "Enabled: true\n";
        data << "AcrossComments: true\n";
      data << "AlignConsecutiveShortCaseStatements:\n\t"
        data << "Enabled: true\n";
        data << "AcrossEmptyLines: true\n";
        data << "AcrossComments: true\n";
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
      data << "SpacesInParens: Never\n\n";
    end

    File.write "#{name}/.clang-format", data;
  end

  # Creates the initial README.md file
  private def generate_readme
    puts "  #{ARROW} README.md";

    data = String.build do |data|
      data << "# #{name}\n\n";

      data << "TODO: Write a description here\n\n";

      data << "# Installation\n\n";

      data << "TODO: Write installation instructions here\n\n";

      data << "## Usage\n\n";

      data << "TODO: Write usage instructions here\n\n";

      data << "## Development\n\n";

      data << "TODO: Write development instructions here\n\n";

      data << "## Contributing\n\n";

      data << "1. Fork it (<https://github.com/your-github-user/#{name}/fork>)\n";
      data << "2. Create your feature branch (`git checkout -b my-new-feature`)\n";
      data << "3. Commit your changes (`git commit -am 'Add some feature'`)\n";
      data << "4. Push to the branch (`git push origin my-new-feature`)\n";
      data << "5. Create a new Pull Request\n\n";

      data << "## Contributors\n\n";

      data << "- [YourName](https://github.com/your-github-user) - creator and maintainer\n";
      data << "";
    end

    File.write "#{name}/README.md", data;
  end

  # Creates the dummy source directory
  private def create_source_directories
    TerminalHandler.mkdir "#{name}/src";
    TerminalHandler.mkdir "#{name}/src/get_value";
  end

  # Create a dummy main source file
  private def create_src_main
    puts "    #{ARROW} #{name}.c";

    data = String.build do |data|
      data << "#include <stdio.h>\n\n";

      data << "#include \"./get_value/get_value.h\"\n\n";

      data << "int main(void) {\n";
      data << "  printf(\"%s\\n\", get_value());\n";
      data << "  return 0;\n";
      data << "}\n";
    end

    File.write "#{name}/src/#{name}.c", data;
  end

  # Create a dummy lib source file
  private def create_value_main
    puts "      #{ARROW} get_value.c";

    data = String.build do |data|
      data << "#include \"get_value.h\"\n\n";

      data << "char *get_value(void) { return \"Hello, World!\"; }\n";
    end

    File.write "#{name}/src/get_value/get_value.c", data;
  end

  # Creates a dummy lib header file
  private def create_value_header
    puts "      #{ARROW} get_value.h";

    data = String.build do |data|
      data << "#ifndef __GET_VALUE_H_\n";
      data << "#define __GET_VALUE_H_\n\n";
 
      data << "/**\n";
      data << " * @func: get_value\n";
      data << " * @brief Returns a greeting as a char*\n";
      data << " * @return char* -> \"Hello, World!\"\n";
      data << " */\n";
      data << "char *get_value(void);\n\n";

      data << "#endif\n";
    end

    File.write "#{name}/src/get_value/get_value.h", data;
  end

  private def create_source_files
    puts "  #{ARROW} src";
    create_src_main;
    puts "    #{ARROW} get_value";
    create_value_main;
    create_value_header;
  end

  # Cretes a dummy spec file using cSpec
  private def create_spec_main
    puts "    #{ARROW} #{name}.spec.c";

    data = String.build do |data|
      data << "#include \"./get_value/get_value.module.spec.h\"\n\n";

      data << "spec_suite({\n";
      data << "  T_get_value();\n";
      data << "});\n\n";

      data << "int main(void) {\n";
      data << "  run_spec_suite(\"all\");\n";
      data << "}\n";
    end

    File.write "#{name}/spec/#{name}.spec.c", data;
  end

  # Cretes a dummy spec for get_value
  private def create_spec_get_value
    puts "      #{ARROW} get_value.module.spec.h";

    data = String.build do |data|
      data << "#include \"../../libs/cSpec/export/cSpec.h\"\n\n";

      data << "#include \"../../src/get_value/get_value.h\"\n\n";

      data << "module(T_get_value, {\n";
      data << "  describe(\"#get_value\", {\n";
      data << "    it(\"returns `Hello, World!`\", {\n";
      data << "      assert_that_charptr(get_value() equals to \"Hello, World!\");\n";
      data << "    });\n";
      data << "  });\n";
      data << "})\n";
    end

    File.write "#{name}/spec/get_value/get_value.module.spec.h", data;
  end

  # Calls the create methods
  private def create_spec_files
    TerminalHandler.mkdir "#{name}/spec";
    TerminalHandler.mkdir "#{name}/spec/get_value";
    puts "  #{ARROW} spec";
    create_spec_main;
    puts "    #{ARROW} get_value";
    create_spec_get_value;
  end

  def message
    "Emeralds - Initializing a new project";
  end

  # Initialize a new emfile with the name specified
  def block
    -> {
      @name = ARGV[1];

      create_lib_directory;
      puts "#{COG} Writing initial files:";
      write_em_file;
      initialize_git_directory;
      wget_a_gplv3_license;
      write_gitignore_file;
      create_clang_format;
      generate_readme;
      create_source_directories;
      create_source_files;
      create_spec_files;
    };
  end
end
