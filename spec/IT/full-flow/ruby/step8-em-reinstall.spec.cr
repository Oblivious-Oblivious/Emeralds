include RubyFlow;

describe "ruby step 8 - em reinstall / em uninstall" do
  it "reinstalls the dependencies" do
    pending "ruby toolchain required" unless RubyFlow.tools?;
    ruby_em("reinstall").should contain("bundle install");
  end

  it "delegates uninstall to bundler" do
    ruby_em("uninstall rspec").should contain("handled through `bundler`");
  end

  it "rejects an empty or blank dependency name" do
    ruby_em_raw(["uninstall", ""]).should contain("Invalid name");
    ruby_em_raw(["uninstall", "   "]).should contain("Invalid name");
  end
end
