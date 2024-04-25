class Emeralds::GenerateMakefile < Emeralds::Command
  def message
    "Emeralds - Generating a makefile...";
  end

  # Generates a makefile for compiling apps without Emeralds
  def block
    -> {
      puts "  #{ARROW} Makefile";

      data = String.build do |data|
        data << "NAME = #{Emeralds::OPT["name"]}\n\n";

        data << "CC = #{Emeralds::OPT["cc"]}\n";
        data << "DEBUG_OPT = #{Emeralds::OPT["debug_opt"]}\n";
        data << "DEBUG_VERSION = #{Emeralds::OPT["debug_version"]}\n";
        data << "DEBUG_FLAGS = #{Emeralds::OPT["debug_flags"]}\n\n";

        data << "RELEASE_OPT = #{Emeralds::OPT["release_opt"]}\n";
        data << "RELEASE_VERSION = #{Emeralds::OPT["release_version"]}\n";
        data << "RELEASE_FLAGS = #{Emeralds::OPT["release_flags"]}\n\n";

        data << "WARNINGS = #{Emeralds::OPT["debug_warnings"]}\n";
        data << "UNUSED_WARNINGS = #{Emeralds::OPT["unused_warnings"]}\n";
        data << "RELEASE_WARNINGS = #{Emeralds::OPT["release_warnings"]}\n";
        data << "TEST_WARNINGS = #{Emeralds::OPT["test_warnings"]}\n";
        data << "LIBS = #{Emeralds::OPT["libs"]}\n";
        data << "DEPS = $(shell #{Emeralds::OPT["deps"]})\n\n";

        data << "INPUTFILES = $(shell #{Emeralds::OPT["inputfiles"]})\n";
        data << "INPUT = $(shell #{Emeralds::OPT["input"]})\n";
        data << "OUTPUT = #{Emeralds::OPT["output"]}\n\n";

        data << "TESTINPUT = $(shell #{Emeralds::OPT["testinput"]})\n";
        data << "TESTOUTPUT = #{Emeralds::OPT["testoutput"]}\n\n";

        data << "all: app_debug\n\n";

        data << "make_export:\n\t";
          data << "$(RM) -r export && mkdir export\n\n";

        data << "copy_headers:\n\t";
          data << "mkdir export/$(NAME) && mkdir export/$(NAME)/headers\n\t";
          data << "cp -r src/$(NAME)/headers/* export/$(NAME)/headers/ >/dev/null 2>&1 || true\n\t";
          data << "cp src/$(NAME).h export/ >/dev/null 2>&1 || true\n\n";

        data << "app_debug: make_export\n\t";
          data << "$(CC) $(DEBUG_OPT) $(DEBUG_VERSION) $(DEBUG_FLAGS) $(WARNINGS) $(UNUSED_WARNINGS) -o $(OUTPUT) $(INPUT) $(INPUTFILES) $(DEPS)\n\t";
          data << "mv $(OUTPUT) export/ >/dev/null 2>&1 || true\n\n";

        data << "app_release: make_export\n\t";
          data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(RELEASE_WARNINGS) -o $(OUTPUT) $(INPUT) $(INPUTFILES) $(DEPS)\n\t";
          data << "mv $(OUTPUT) export/ >/dev/null 2>&1 || true\n\n";

        data << "lib_debug: make_export copy_headers\n\t";
          data << "$(CC) $(DEBUG_OPT) $(DEBUG_VERSION) $(DEBUG_FLAGS) $(WARNINGS) $(UNUSED_WARNINGS) $(LIBS) $(INPUTFILES)\n\t";
          data << "mv *.o export/ >/dev/null 2>&1 || true\n\t";
          data << "mv $(shell find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true\n\n";

        data << "lib_release: make_export copy_headers\n\t";
          data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(RELEASE_WARNINGS) $(LIBS) $(INPUTFILES)\n\t";
          data << "mv *.o export/ >/dev/null 2>&1 || true\n\t";
          data << "mv $(shell find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true\n\n";

        data << "test: lib_release\n\t";
          data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(TEST_WARNINGS) -o spec/$(TESTOUTPUT) $(DEPS) $(TESTINPUT)\n\t";
          data << "@echo\n\t";
          data << "./spec/$(TESTOUTPUT)\n\n";

        data << "spec: test\n\n";

        data << "clean:\n\t";
          data << "$(RM) -r spec/$(TESTOUTPUT)\n\t";
          data << "$(RM) -r export *.dSYM\n\n";
      end

      File.write "Makefile", data;
    };
  end
end
