require "spec"

# Avoid running main
require "../src/emeralds/constants/cli"
require "../src/emeralds/constants/version"

require "../src/emeralds/modules/compiler_options_helper"
require "../src/emeralds/modules/file_creator_helper"
require "../src/emeralds/modules/yaml_helper"

require "../src/emeralds/command_processor"

# Fix the test output
FileUtils.rm_rf "testapp";
