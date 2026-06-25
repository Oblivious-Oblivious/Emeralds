include RubyFlow;

describe "ruby step 6 - em list / loc / lint / version / license" do
  it "lists dependencies and modules" do
    output = ruby_em("list");
    output.should contain("Dependencies:");
    output.should contain("Modules:");
    output.should contain("get-value");
  end

  it "counts the lines of code" do
    ruby_em("loc").should contain("SUM:");
  end

  it "lints the sources" do
    if Process.find_executable("rubocop").nil?
      ruby_em("lint").should contain("rubocop not found");
    else
      output = ruby_em("lint");
      output.should contain("files inspected");
    end
  end

  it "prints the version" do
    ruby_em("version").should contain("__testing__ v0.0.1");
  end

  it "downloads the license" do
    ruby_em("license").should contain("LICENSE");
    File.read(File.join(RubyFlow::PROJECT, "LICENSE")).should contain("MIT License");
  end
end
