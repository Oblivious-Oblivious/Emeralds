# Holds CLI options parsed from double-dash arguments
class Emeralds::Options
  class_property author : String? = nil;

  def self.parse_args
    build_parser.parse ARGV;
  end

  # The formatted usage text for the available options.
  def self.usage
    build_parser.to_s;
  end

  # Consumes recognized `--flag value` options from ARGV into the matching
  # options and leaves ARGV holding the remaining arguments.
  private def self.build_parser
    OptionParser.new do |parser|
      parser.banner = "Options:";
      parser.on("--author NAME", "   - Set the project author") { |name| self.author = name; };
      parser.invalid_option { };
      parser.missing_option { };
    end
  end
end
