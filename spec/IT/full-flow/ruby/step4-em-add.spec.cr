include RubyFlow;

describe "ruby step 4 - em add / em remove" do
  it "adds module one" do
    ruby_em("add one").should contain("one.rb");
    File.exists?(File.join(RubyFlow::PROJECT, "src", "one", "one.rb")).should be_true;
    File.exists?(File.join(RubyFlow::PROJECT, "spec", "one", "one_spec.rb")).should be_true;
  end

  it "adds modules two and three" do
    ruby_em("add two").should contain("two.rb");
    ruby_em("add three").should contain("three.rb");
  end

  it "removes module one" do
    ruby_em("remove one").should contain("one.rb");
    File.exists?(File.join(RubyFlow::PROJECT, "src", "one", "one.rb")).should be_false;
    File.exists?(File.join(RubyFlow::PROJECT, "spec", "one", "one_spec.rb")).should be_false;
  end

  it "removes modules two and three" do
    ruby_em("remove two").should contain("two.rb");
    ruby_em("remove three").should contain("three.rb");
  end

  it "adds nested module files" do
    output = ruby_em("add module/subfolder/test");

    output.should contain("module/subfolder/test.rb");
    File.exists?(File.join(RubyFlow::PROJECT, "src", "module", "subfolder", "test.rb")).should be_true;
    File.exists?(File.join(RubyFlow::PROJECT, "spec", "module", "subfolder", "test_spec.rb")).should be_true;
    main = File.read(File.join(RubyFlow::PROJECT, "src", "__testing__.rb"));
    main.should contain("require_relative \"module/subfolder/test\";");
    helper = File.read(File.join(RubyFlow::PROJECT, "spec", "spec_helper.rb"));
    helper.should contain("require_relative \"./module/subfolder/test_spec\";");
  end

  it "removes nested module files" do
    ruby_em("remove module/subfolder/test").should contain("module/subfolder/test.rb");

    File.exists?(File.join(RubyFlow::PROJECT, "src", "module", "subfolder", "test.rb")).should be_false;
    File.exists?(File.join(RubyFlow::PROJECT, "spec", "module", "subfolder", "test_spec.rb")).should be_false;
    main = File.read(File.join(RubyFlow::PROJECT, "src", "__testing__.rb"));
    main.should_not contain("require_relative \"module/subfolder/test\";");
  end

  it "refuses to add or remove the top-level project source" do
    ruby_em("add __testing__").should_not contain("reserved");
    File.exists?(File.join(RubyFlow::PROJECT, "src", "__testing__", "__testing__.rb")).should be_true;
    File.exists?(File.join(RubyFlow::PROJECT, "src", "__testing__.rb")).should be_true;

    ruby_em("remove __testing__").should_not contain("reserved");
    File.exists?(File.join(RubyFlow::PROJECT, "src", "__testing__", "__testing__.rb")).should be_false;
    File.exists?(File.join(RubyFlow::PROJECT, "src", "__testing__.rb")).should be_true;
  end

  it "rejects an empty module name" do
    ruby_em_raw(["add", ""]).should contain("Invalid name");
    ruby_em_raw(["remove", ""]).should contain("Invalid name");
  end
end
