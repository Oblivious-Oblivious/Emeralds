require "../../spec_helper";

describe Emeralds::Init do
  it "accepts safe project names and rejects unsafe paths" do
    init = Emeralds::Init.new;

    init.validate_filename("sample").should be_true;
    init.validate_filename("../sample").should be_false;
    init.validate_filename("aux").should be_false;
  end
end
