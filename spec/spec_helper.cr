require "spec";
require "yaml";
require "file_utils";

# Avoid running main
require "../src/emeralds/constants/cli";
require "../src/emeralds/constants/version";

require "../src/emeralds/modules/YamlReader";

# Fix the test output
FileUtils.rm_rf "testapp";
