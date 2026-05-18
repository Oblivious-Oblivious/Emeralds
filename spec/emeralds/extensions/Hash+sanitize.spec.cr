require "../../spec_helper";

describe Hash do
  describe "#sanitize" do
    it "rejects entries with empty keys or values without mutating the hash" do
      deps = {
        "good" => "owner/good",
        "" => "owner/empty-key",
        "empty-value" => "",
      };

      deps.sanitize.should eq({"good" => "owner/good"});
      deps.size.should eq 3;
    end
  end
end
