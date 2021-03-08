require "spec"

# Avoid running main
require "../src/emeralds/cli"
require "../src/emeralds/version"
require "../src/emeralds/command_processor"
require "../src/emeralds/yaml_processor"

# Fix the test output
FileUtils.rm_rf "testapp";
