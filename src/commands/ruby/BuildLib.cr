{% for name, label in {"Debug" => "debug", "Release" => "release", "Dev" => "dev", "Stage" => "stage", "Preprod" => "preprod", "Prod" => "prod"} %}
  class Emeralds::Ruby::BuildLib{{name.id}} < Emeralds::BuildLib{{name.id}}
    def block
      -> {
        Ruby::Build.new.build_lib Emfile.instance.compile_flags.{{label.id}};
      };
    end
  end
{% end %}
