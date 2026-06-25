{% for name, label in {"Debug" => "debug", "Release" => "release", "Dev" => "dev", "Stage" => "stage", "Preprod" => "preprod", "Prod" => "prod"} %}
  class Emeralds::Ruby::BuildApp{{name.id}} < Emeralds::BuildApp{{name.id}}
    def block
      -> {
        Ruby::Build.new.build_app Emfile.instance.compile_flags.{{label.id}};
      };
    end
  end
{% end %}
