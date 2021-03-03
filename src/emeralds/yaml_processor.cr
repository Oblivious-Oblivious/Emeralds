require "yaml"

class Emeralds::YamlProcessor
    private def read_and_return(field, from) : String
        if from[field].to_s == "nil"
            "";
        else
            from[field].to_s;
        end
    end

    private def read_and_return_dependencies(from) : Array(String)
        if !from["dependencies"]
            [] of String;
        else
            # Remove brackets and split at commas
            from["dependencies"]
                .to_s
                .lstrip("{")
                .rstrip("}")
                .split(", ");
        end
    end

    def get_dependencies : Array(String)
        if File.exists?("em.yml")
            yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;
            
            read_and_return_dependencies from: yaml;
        else
            [] of String;
        end
    end

    def get_field(field : String ) : String
        if File.exists?("em.yml")
            yaml = File.open("em.yml") { |f| YAML.parse f; }.as_h;

            read_and_return field, from: yaml;
        else
            "";
        end
    end

    def get_lines_of_code : Array(Int32)
        num = 0;
        loc = 0;

        Dir.glob PATHS do |file|
            num += 1;
            loc += File
                .read(file)
                .split("\n")
                .select { |line| line != "" }
                .size;
        end
        
        [num, loc];
    end
end
