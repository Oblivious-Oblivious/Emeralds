# A module for setting options and compile flags
# Also can generate a makefile with those options for standalone usage
module Emeralds::CompilerOptionsHelper
  def self.make_export
    `rm -rf export && mkdir export`;
  end

  def self.copy_headers
    `mkdir export/#{Emeralds::OPT["name"]} && mkdir export/#{Emeralds::OPT["name"]}/headers`;
    `cp -r src/#{Emeralds::OPT["name"]}/headers/* export/#{Emeralds::OPT["name"]}/headers/ >/dev/null 2>&1 || true`;
    `cp src/#{Emeralds::OPT["name"]}.h export/ >/dev/null 2>&1 || true`;
  end

  def self.move_output_to_export
    `mv #{Emeralds::OPT["output"]} export/ >/dev/null 2>&1 || true`;
  end

  def self.copy_libraries_to_export
    `mv *.o export/ >/dev/null 2>&1 || true`;
    `cp -r $(find ./libs -name "*.*o") export/ >/dev/null 2>&1 || true`;
  end

  def self.application_debug
    self.make_export;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["debug_opt"]} #{Emeralds::OPT["debug_version"]} #{Emeralds::OPT["debug_flags"]} #{Emeralds::OPT["warnings"]} #{Emeralds::OPT["remove_warnings"]} #{Emeralds::OPT["unused_warnings"]} -o #{Emeralds::OPT["output"]} #{Emeralds::OPT["input"]} #{Emeralds::OPT["inputfiles"]} #{Emeralds::OPT["deps"]} 2>&1 | grep -v \"no input files\"";
    puts cmd;
    `#{cmd}`;
    self.move_output_to_export;
  end

  def self.application_release
    self.make_export;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} -o #{Emeralds::OPT["output"]} #{Emeralds::OPT["input"]} #{Emeralds::OPT["inputfiles"]} #{Emeralds::OPT["deps"]} 2>&1 | grep -v \"no input files\"";
    puts cmd;
    `#{cmd}`;
    self.move_output_to_export;
  end

  def self.library_debug
    self.make_export;
    self.copy_headers;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["debug_opt"]} #{Emeralds::OPT["debug_version"]} #{Emeralds::OPT["debug_flags"]} #{Emeralds::OPT["warnings"]} #{Emeralds::OPT["remove_warnings"]} #{Emeralds::OPT["unused_warnings"]} #{Emeralds::OPT["libs"]} #{Emeralds::OPT["inputfiles"]} 2>&1 | grep -v \"no input files\"";
    puts cmd;
    `#{cmd}`;
    self.copy_libraries_to_export;
  end

  def self.library_release
    self.make_export;
    self.copy_headers;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} #{Emeralds::OPT["libs"]} #{Emeralds::OPT["inputfiles"]} 2>&1 | grep -v \"no input files\"";
    puts cmd;
    `#{cmd}`;
    self.copy_libraries_to_export;
  end

  def self.test_script
    self.copy_libraries_to_export;
    self.library_release;
    cmd = "#{Emeralds::OPT["cc"]} #{Emeralds::OPT["release_opt"]} #{Emeralds::OPT["release_version"]} #{Emeralds::OPT["release_flags"]} #{Emeralds::OPT["test_warnings"]} -o spec/#{Emeralds::OPT["testoutput"]} #{Emeralds::OPT["deps"]} #{Emeralds::OPT["testinput"]} 2>&1 | grep -v \"no input files\"";
    `mkdir export >/dev/null 2>&1 || true`;
    puts cmd;
    `#{cmd}`;
    puts;
    puts "./spec/#{Emeralds::OPT["testoutput"]}";
    puts `./spec/#{Emeralds::OPT["testoutput"]}`;
    true;
  end

  def self.clean_script
    puts "rm -rf spec/#{Emeralds::OPT["testoutput"]}";
    `rm -rf spec/#{Emeralds::OPT["testoutput"]}`;
    puts "rm -rf export";
    `rm -rf export`;
    true;
  end

  # Creates the initial makefile for compilations
  def self.generate_makefile
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

      data << "WARNINGS = #{Emeralds::OPT["warnings"]}\n";
      data << "UNUSED_WARNINGS = #{Emeralds::OPT["unused_warnings"]}\n";
      data << "REMOVE_WARNINGS = #{Emeralds::OPT["remove_warnings"]}\n";
      data << "TEST_WARNINGS = #{Emeralds::OPT["test_warnings"]}\n";
      data << "LIBS = #{Emeralds::OPT["libs"]}\n";
      # TODO Differs from options
      data << "DEPS = $(shell find ./export -name \"*.*o\")\n\n";

      data << "INPUTFILES = #{Emeralds::OPT["inputfiles"]}\n";
      data << "INPUT = #{Emeralds::OPT["input"]}\n";
      data << "OUTPUT = #{Emeralds::OPT["output"]}\n\n";

      data << "TESTINPUT = #{Emeralds::OPT["testinput"]}\n";
      data << "TESTOUTPUT = #{Emeralds::OPT["testoutput"]}\n\n";

      data << "all: app_debug\n\n";

      # TODO Keep formatting
      data << "make_export:\n\t";
        data << "$(RM) -r export && mkdir export\n\n";

      data << "copy_headers:\n\t";
        data << "mkdir export/$(NAME) && mkdir export/$(NAME)/headers\n\t";
        data << "cp -r src/$(NAME)/headers/* export/$(NAME)/headers/ >/dev/null 2>&1 || true\n\t";
        data << "cp src/$(NAME).h export/ >/dev/null 2>&1 || true\n\n";

      data << "app_debug: make_export\n\t";
        data << "$(CC) $(DEBUG_OPT) $(DEBUG_VERSION) $(DEBUG_FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) -o $(OUTPUT) $(INPUT) $(INPUTFILES) $(DEPS)\n\t";
        data << "mv $(OUTPUT) export/ >/dev/null 2>&1 || true\n\n";

      data << "app_release: make_export\n\t";
        data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) -o $(OUTPUT) $(INPUT) $(INPUTFILES) $(DEPS)\n\t";
        data << "mv $(OUTPUT) export/ >/dev/null 2>&1 || true\n\n";

      data << "lib_debug: make_export copy_headers\n\t";
        data << "$(CC) $(DEBUG_OPT) $(DEBUG_VERSION) $(DEBUG_FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) $(INPUTFILES)\n\t";
        data << "mv *.o export/ >/dev/null 2>&1 || true\n\t";
        data << "mv $(shell find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true\n\n";

      data << "lib_release: make_export copy_headers\n\t";
        data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(LIBS) $(INPUTFILES)\n\t";
        data << "mv *.o export/ >/dev/null 2>&1 || true\n\t";
        data << "mv $(shell find ./libs -name \"*.*o\") export/ >/dev/null 2>&1 || true\n\n";

      data << "test: lib_release\n\t";
        data << "$(CC) $(RELEASE_OPT) $(RELEASE_VERSION) $(RELEASE_FLAGS) $(TEST_WARNINGS) -o spec/$(TESTOUTPUT) $(DEPS) $(TESTINPUT)\n\t";
        data << "@echo\n\t";
        data << "./spec/$(TESTOUTPUT)\n\n";

      data << "spec: test\n\n";
        data << "clean:\n\t";
        data << "$(RM) -r spec/$(TESTOUTPUT)\n\t";
        data << "$(RM) -r export\n\n";
    end

    File.write "Makefile", data;
  end
end
