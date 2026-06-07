TAG_PROJECT = File.join SANDBOX, "__tag_testing__";

private def read_project_emfile
  File.read File.join(PROJECT, "em.json");
end

private def write_tag_project_emfile(version)
  emfile_path = File.join TAG_PROJECT, "em.json";
  raw = File.read emfile_path;
  updated = raw.sub(
    "\"https://github.com/Oblivious-Oblivious/cSpec\": \"latest\"",
    "\"https://github.com/Oblivious-Oblivious/cSpec\": \"#{version}\""
  );
  File.write emfile_path, updated;
end

describe "step 7 - em install link" do
  it "adds and installs a dependency from a git link" do
    output = em "install https://github.com/Oblivious-Oblivious/cSpec";

    output.should contain("`cSpec` already installed");
    read_project_emfile.should contain("\"https://github.com/Oblivious-Oblivious/cSpec\": \"latest\"");
    File.exists?(File.join(PROJECT, "libs", "cSpec", "export", "cSpec.h")).should be_true;
  end

  it "does not duplicate an existing git dependency" do
    em "install https://github.com/Oblivious-Oblivious/cSpec";

    read_project_emfile.scan("https://github.com/Oblivious-Oblivious/cSpec").size.should eq(1);
  end

  it "rejects an empty or blank install argument" do
    em_raw(["install", ""]).should contain("Invalid name");
    em_raw(["install", "   "]).should contain("Invalid name");
  end

  it "installs a tagged dependency archive" do
    FileUtils.rm_rf TAG_PROJECT;
    em_sandbox "init __tag_testing__";
    write_tag_project_emfile "0.3.2";

    output = em_at "install all", TAG_PROJECT;

    output.should contain("Installing `cSpec`");
    File.exists?(File.join(TAG_PROJECT, "libs", "cSpec", "export", "cSpec.h")).should be_true;
    em_at("test", TAG_PROJECT).should contain("1 passing");
  end
end
