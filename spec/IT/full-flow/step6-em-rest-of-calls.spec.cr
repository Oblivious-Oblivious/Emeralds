describe "step 6 - em list / makefile / loc / lint / version / license" do
  it "lists dependencies and modules" do
    em("list").should contain("cSpec");
  end

  it "generates an empty makefile" do
    em "makefile";
    File.read(File.join(PROJECT, "Makefile")).should be_empty;
  end

  it "counts the lines of code" do
    em("loc").should contain("SUM:");
  end

  it "lints the sources" do
    output = em("lint");
    output.should contain("Linting sources");
    output.should contain("src/get_value/get_value.c");
    output.should contain("src/get_value/get_value.h");
    output.should contain("src/__testing__.c");
  end

  it "prints the version" do
    em("version").should contain("v0.0.1");
  end

  it "downloads the license" do
    em("license").should contain("LICENSE");
    File.read(File.join(PROJECT, "LICENSE")).should contain("MIT License");
  end
end
