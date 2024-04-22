class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  # Runs the clean script defined in the em.yml file
  def block
    -> {
      puts "rm -rf spec/#{Emeralds::OPT["testoutput"]}";
      `rm -rf spec/#{Emeralds::OPT["testoutput"]}`;
      puts "rm -rf export *.dSYM";
      `rm -rf export *.dSYM`;
    };
  end
end
