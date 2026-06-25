include CrystalFlow;

describe "crystal step 3 - em test" do
  it "runs the seeded spec without installing dependencies" do
    pending "crystal toolchain required" unless CrystalFlow.tools?;
    output = crystal_em("test");
    output.should contain("1 example");
  end
end
