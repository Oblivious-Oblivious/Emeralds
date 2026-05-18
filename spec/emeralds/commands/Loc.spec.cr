require "../../spec_helper";

describe Emeralds::Loc do
  it "counts source and spec files in a temporary emerald repo" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "loc";
    end
  end

  it "ignores configured extensions and directories" do
    EmeraldsSpec.in_temp_dir do
      File.write "em.json", %({
        "locignore": {
          "extensions": [".h", ".json"],
          "directories": ["vendor"]
        }
      });
      FileUtils.mkdir_p "src";
      FileUtils.mkdir_p "vendor";
      File.write File.join("src", "main.c"), "int main(void) {\nreturn 0;\n}\n";
      File.write File.join("src", "generated.h"), "int generated(void) {\nreturn 1;\n}\n";
      File.write File.join("vendor", "lib.c"), "int vendor(void) {\nreturn 2;\n}\n";

      output = IO::Memory.new;
      error = IO::Memory.new;
      status = Process.run EmeraldsSpec.em_bin, ["loc"], output: output, error: error;

      status.success?.should be_true;
      output.to_s.should contain "SUM:";
      output.to_s.should contain "         1          3";
    end
  end
end
