require "../../spec_helper";

describe Emeralds::Terminal do
  it "creates, copies, moves, and removes filesystem paths" do
    EmeraldsSpec.in_temp_dir do
      Emeralds::Terminal.mkdir File.join("src", "headers");
      File.write File.join("src", "headers", "spec.h"), "";
      Emeralds::Terminal.mkdir "export";

      Emeralds::Terminal.cp File.join("src", "headers", "*.h"), "export";
      File.exists?(File.join("export", "spec.h")).should be_true;

      Emeralds::Terminal.mkdir "include";
      Emeralds::Terminal.mv [File.join("export", "spec.h")], "include";
      File.exists?(File.join("include", "spec.h")).should be_true;
      File.exists?(File.join("export", "spec.h")).should be_false;

      Emeralds::Terminal.rm File.join("include", "spec.h");
      File.exists?(File.join("include", "spec.h")).should be_false;
    end
  end

  it "finds files matching a glob and deduplicates by basename" do
    EmeraldsSpec.in_temp_dir do
      FileUtils.mkdir_p File.join("src", "one");
      FileUtils.mkdir_p File.join("src", "two");
      File.write File.join("src", "one", "same.c"), "";
      File.write File.join("src", "two", "same.c"), "";
      File.write File.join("src", "two", "other.c"), "";
      FileUtils.mkdir_p File.join("src", "two", "nested.c");

      matches = Emeralds::Terminal.find(File.join("src", "*", "*.c"));

      matches.map { |path| path.split('/').last }.sort.should eq ["other.c", "same.c"];
      matches.any? { |path| path.ends_with? File.join("two", "other.c") }.should be_true;
    end
  end

  it "reports source, input, output, dependency, and include paths" do
    EmeraldsSpec.in_temp_dir do
      FileUtils.mkdir_p File.join("src", "module");
      FileUtils.mkdir_p "spec";
      FileUtils.mkdir_p File.join("libs", "alpha", "export", "include");
      FileUtils.mkdir_p File.join("libs", "beta", "export");

      File.write File.join("src", "main.c"), "";
      File.write File.join("src", "module", "module.c"), "";
      File.write File.join("src", "module", "module.a"), "";
      File.write File.join("src", "module", "module.a.test"), "";
      File.write File.join("spec", "spec.spec.c"), "";
      File.write File.join("libs", "alpha", "export", "alpha.a"), "";
      File.write File.join("libs", "alpha", "export", "alpha.a.test"), "";
      File.write File.join("libs", "alpha", "export", "include", "alpha.h"), "";
      File.write File.join("libs", "beta", "export", "beta.a"), "";

      Emeralds::Emfile.with_instance Emeralds::Emfile.from_json(%({"name":"spec"})) do
        Emeralds::Terminal.sources_app.split.sort.should eq [
          File.join("src", "module", "module.a"),
          File.join("src", "module", "module.c"),
        ].sort;
        Emeralds::Terminal.sources_lib.should eq File.join("src", "module", "module.c");
        Emeralds::Terminal.sources_test.split.sort.should eq [
          File.join("src", "module", "module.a.test"),
          File.join("src", "module", "module.c"),
        ].sort;
        Emeralds::Terminal.deps_release.split.sort.should eq [
          File.join("libs", "alpha", "export", "alpha.a"),
          File.join("libs", "beta", "export", "beta.a"),
        ].sort;
        Emeralds::Terminal.deps_test.should eq File.join("libs", "alpha", "export", "alpha.a.test");
        Emeralds::Terminal.deps_for_test.split.sort.should eq [
          File.join("libs", "alpha", "export", "alpha.a.test"),
          File.join("libs", "beta", "export", "beta.a"),
        ].sort;
        Emeralds::Terminal.deps_includes.split.sort.should eq [
          "-I#{File.join("libs", "alpha", "export")}",
          "-I#{File.join("libs", "alpha", "export", "include")}",
          "-I#{File.join("libs", "beta", "export")}",
        ].sort;
        Emeralds::Terminal.input_app.should eq File.join("src", "main.c");
        Emeralds::Terminal.input_test.should eq File.join("spec", "spec.spec.c");
        Emeralds::Terminal.output_app.should eq File.join("export", "spec");
        Emeralds::Terminal.output_lib.should eq "spec.a";
        Emeralds::Terminal.output_test.should eq File.join("spec", "spec_results");
      end
    end
  end
end
