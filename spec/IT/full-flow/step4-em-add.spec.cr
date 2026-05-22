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
end
