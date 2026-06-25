include RubyFlow;

describe "ruby step 3 - em test" do
  it "runs the seeded spec without installing dependencies" do
    pending "ruby toolchain required" unless RubyFlow.tools?;
    output = ruby_em("test");
    output.should contain("1 example");
  end

  it "installs all dependencies" do
    pending "ruby toolchain required" unless RubyFlow.tools?;
    ruby_em("install").should contain("Resolving dependencies");
  end

  it "runs the tests after installing" do
    pending "ruby toolchain required" unless RubyFlow.tools?;
    ruby_em("test").should contain("1 example");
    ruby_em("test").should contain("0 failures");
  end
end
