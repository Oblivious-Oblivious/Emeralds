describe "step 6 - em list / loc / lint / version / license" do
  it "lists dependencies and modules" do
    em("list").should contain("cSpec");
  end

  it "counts the lines of code" do
    em("loc").should contain("SUM:");
  end

  it "lints the sources" do
    output = em("lint");
    output.should contain("Linting sources");
    output.should contain("src/get-value/get-value.c");
    output.should contain("src/get-value/get-value.h");
    output.should contain("src/__testing__.c");
    output.should contain("spec/__testing__.spec.c");
    output.should contain("spec/get-value/get-value.module.spec.h");
    File.exists?(File.join(PROJECT, "clang-tidy.out")).should be_false;
    File.exists?(File.join(PROJECT, "clang-analyze.out")).should be_false;
  end

  it "writes lint analysis output when requested" do
    output_path = File.join(PROJECT, "analysis.out");
    File.delete(output_path) if File.exists? output_path;

    output = em_raw(["lint", "--output", "analysis.out"]);
    tools = ["clang-tidy"];

    if tools.all? { |tool| Process.find_executable tool }
      output.should contain("Analysis findings written to analysis.out");
      File.exists?(output_path).should be_true;
    else
      output.should contain("Skipping static analysis");
      File.exists?(output_path).should be_false;
    end
  end

  it "prints the version" do
    em("version").should contain("v0.0.1");
  end

  it "downloads the license" do
    em("license").should contain("LICENSE");
    File.read(File.join(PROJECT, "LICENSE")).should contain("MIT License");
  end
end
