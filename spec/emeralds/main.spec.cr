require "../spec_helper";

describe Emeralds::Main do
  it "runs a script instead of the built-in command with the same name" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({
        "scripts": {
          "clean": "touch script-clean-ran"
        }
      });
      EmeraldsSpec.em "build", "app", "debug";

      EmeraldsSpec.em "clean";

      File.exists?("script-clean-ran").should be_true;
      Dir.exists?("export").should be_true;
    end
  end

  it "falls back to the built-in command when scripts are missing" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({});
      EmeraldsSpec.em "build", "app", "debug";

      EmeraldsSpec.em "clean";

      Dir.exists?("export").should be_false;
    end
  end

  it "falls back to the built-in command when no matching script exists" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({
        "scripts": {
          "setup": "touch setup-ran"
        }
      });
      EmeraldsSpec.em "build", "app", "debug";

      EmeraldsSpec.em "clean";

      File.exists?("setup-ran").should be_false;
      Dir.exists?("export").should be_false;
    end
  end

  it "executes empty commands" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({
        "scripts": {
          "clean": "   "
        }
      });
      EmeraldsSpec.em "build", "app", "debug";

      EmeraldsSpec.em "clean";

      Dir.exists?("export").should be_true;
    end
  end

  it "allows scripts to use em.json field names" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({
        "scripts": {
          "dependencies": "touch script-dependencies-ran"
        }
      });

      EmeraldsSpec.em "dependencies";

      File.exists?("script-dependencies-ran").should be_true;
    end
  end

  it "runs array scripts as multiple command lines" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({
        "scripts": {
          "setup": [
            "touch script-array-first-ran",
            "touch script-array-second-ran"
          ]
        }
      });

      EmeraldsSpec.em "setup";

      File.exists?("script-array-first-ran").should be_true;
      File.exists?("script-array-second-ran").should be_true;
    end
  end
end
