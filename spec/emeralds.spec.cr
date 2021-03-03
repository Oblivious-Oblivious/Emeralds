require "./spec_helper"
require "./emeralds/**"

describe Emeralds do
    it "has a version of 1.0.0" do
        Emeralds::VERSION.should eq "0.2.0";
    end
end
