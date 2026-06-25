include RubyFlow;

describe "ruby step 7 - em install" do
  it "installs dependencies through bundler" do
    pending "ruby toolchain required" unless RubyFlow.tools?;
    ruby_em("install").should contain("Resolving dependencies");
  end

  it "delegates `install all` to bundler" do
    ruby_em("install all").should contain("handled through `bundler`");
  end

  it "delegates `install dev` to bundler" do
    ruby_em("install dev").should contain("handled through `bundler`");
  end

  it "rejects an empty or blank install argument" do
    ruby_em_raw(["install", ""]).should contain("Invalid name");
    ruby_em_raw(["install", "   "]).should contain("Invalid name");
  end
end
