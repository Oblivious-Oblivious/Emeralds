describe "CLI" do
    it "defines constants for logging" do
        Emeralds::COG.should eq "⚙".colorize(:light_green).mode(:dim).to_s;
        Emeralds::ARROW.should eq "➔".colorize(:dark_gray).to_s;
        Emeralds::CHECKMARK.should eq "✔".colorize(:light_green).to_s;
        Emeralds::DIAMOND.should eq "◈";
    end
end
