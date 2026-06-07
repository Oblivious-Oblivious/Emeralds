{% for name, label in {"Debug" => "debug", "Release" => "release", "Dev" => "dev", "Stage" => "stage", "Preprod" => "preprod", "Prod" => "prod"} %}
  abstract class Emeralds::BuildApp{{name.id}} < Emeralds::Command
    def message
      "Emeralds - Compiling as an app in (" + {{label}} + ") mode...";
    end
  end
{% end %}
