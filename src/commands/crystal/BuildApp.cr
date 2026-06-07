{% for name, label in {"Debug" => "debug", "Release" => "release", "Dev" => "dev", "Stage" => "stage", "Preprod" => "preprod", "Prod" => "prod"} %}
  class Emeralds::Crystal::BuildApp{{name.id}} < Emeralds::BuildApp{{name.id}}
    def block
      -> {
        Crystal::Build.new.build_app Emfile.instance.compile_flags.{{label.id}};
      };
    end
  end
{% end %}
