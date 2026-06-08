class Emeralds::Options
  TEMPLATES = ["c", "crystal"];

  class_property author : String? = nil;
  class_property template : String = "c";

  macro dispatch_template(command, **named_args)
    case Options.template
    {% for t in TEMPLATES %}
    when {{t}}
      {{t.camelcase.id}}::{{command.id}}.new(**{{named_args}}).run;
    {% end %}
    else
      puts "Invalid template: #{Options.template}. Available: #{Options::TEMPLATES.join(", ")}.".colorize(:red);
      exit 0;
    end
  end

  def self.parse_args
    build_parser.parse ARGV;
  end

  def self.usage
    build_parser;
  end

  private def self.build_parser
    OptionParser.new do |parser|
      parser.banner = "Options:";
      parser.on("--author NAME", "   - Set the project author") { |name|
        self.author = name;
      };
      parser.on("--template NAME", "   - Set the project template (#{TEMPLATES.join(", ")})") { |name|
        self.template = name.downcase;
      };
      parser.invalid_option { };
      parser.missing_option { };
    end
  end
end
