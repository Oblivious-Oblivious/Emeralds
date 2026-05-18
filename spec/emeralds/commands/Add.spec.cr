require "../../spec_helper";

describe Emeralds::Add do
  it "generates a C, header, and spec module trio" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "add", "widget";

      c_file = File.join "src", "widget", "widget.c";
      h_file = File.join "src", "widget", "widget.h";
      spec_file = File.join "spec", "widget", "widget.module.spec.h";

      File.read(c_file).should contain "#include \"widget.h\"";
      File.read(c_file).should contain "char *widget(void)";
      File.read(h_file).should contain "__WIDGET_H_";
      File.read(spec_file).should contain "module(T_widget";
      File.read(spec_file).should contain "../../src/widget/widget.h";
    end
  end

  it "rejects path-like names without creating files" do
    EmeraldsSpec.with_repo do |repo|
      repo.run "add", "../bad";

      Dir.exists?(File.join("src", "..", "bad")).should be_false;
      Dir.exists?(File.join("spec", "..", "bad")).should be_false;
    end
  end
end
