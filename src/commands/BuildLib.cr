{% for name, label in {"Debug" => "debug", "Release" => "release", "Dev" => "dev", "Stage" => "stage", "Preprod" => "preprod", "Prod" => "prod"} %}
  abstract class Emeralds::BuildLib{{name.id}} < Emeralds::Command
    def message
      "Emeralds - Compiling as a library in (" + {{label}} + ") mode...";
    end
  end
{% end %}
