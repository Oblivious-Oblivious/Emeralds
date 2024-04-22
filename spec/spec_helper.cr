require "spec";
require "yaml";
require "file_utils";

# Avoid running main
require "../src/emeralds/constants/cli";
require "../src/emeralds/constants/version";

require "../src/emeralds/modules/YamlHelper";

# Fix the test output
FileUtils.rm_rf "testapp";
