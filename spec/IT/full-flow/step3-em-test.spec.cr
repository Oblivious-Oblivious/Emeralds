describe "step 3 - em test" do
  it "reports cSpec is missing before installing" do
    em("test").should contain("cSpec is not installed");
  end

  it "installs all dependencies" do
    em("install all").should contain("Installing `cSpec`");
  end

  it "runs the tests after installing" do
    em("test").should contain("1 passing");
  end
end
