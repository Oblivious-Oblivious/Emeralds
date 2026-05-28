require "../../spec_helper";

describe "step 4 - em add / em remove" do
  it "adds module one" do
    em("add one").should contain("one.c");
  end

  it "adds modules two and three" do
    em("add two").should contain("two.c");
    em("add three").should contain("three.c");
  end

  it "removes module one" do
    em("remove one").should contain("one.h");
  end

  it "removes modules two and three" do
    em("remove two").should contain("two.h");
    em("remove three").should contain("three.h");
  end

  it "adds nested module files" do
    output = em("add module/subfolder/test");

    output.should contain("module/subfolder/test.c");
    File.exists?(File.join(PROJECT, "src", "module", "subfolder", "test.c")).should be_true;
    File.exists?(File.join(PROJECT, "src", "module", "subfolder", "test.h")).should be_true;
    File.exists?(File.join(PROJECT, "spec", "module", "subfolder", "test.module.spec.h")).should be_true;
    File.read(File.join(PROJECT, "src", "module", "subfolder", "test.h")).should contain("__TESTING_MODULE_SUBFOLDER_TEST_H_");
  end

  it "adds header-only nested module files" do
    output = em("add module/file.h");

    output.should contain("module/file.h");
    File.exists?(File.join(PROJECT, "src", "module", "file.h")).should be_true;
    File.exists?(File.join(PROJECT, "src", "module", "file.c")).should be_false;
    File.exists?(File.join(PROJECT, "spec", "module", "file.module.spec.h")).should be_true;
    File.read(File.join(PROJECT, "src", "module", "file.h")).should contain("char *module_file(void);");
    File.read(File.join(PROJECT, "spec", "module", "file.module.spec.h")).should contain("module(T_module_file, {");
    File.read(File.join(PROJECT, "spec", "__testing__.spec.c")).should contain("T_module_file();");
  end

  it "removes nested module files" do
    em("remove module/subfolder/test").should contain("module/subfolder/test.h");

    File.exists?(File.join(PROJECT, "src", "module", "subfolder", "test.c")).should be_false;
    File.exists?(File.join(PROJECT, "src", "module", "subfolder", "test.h")).should be_false;
    File.exists?(File.join(PROJECT, "spec", "module", "subfolder", "test.module.spec.h")).should be_false;
  end

  it "removes header-only nested module files" do
    em("remove module/file.h").should contain("module/file.h");

    File.exists?(File.join(PROJECT, "src", "module", "file.h")).should be_false;
    File.exists?(File.join(PROJECT, "spec", "module", "file.module.spec.h")).should be_false;
  end
end
