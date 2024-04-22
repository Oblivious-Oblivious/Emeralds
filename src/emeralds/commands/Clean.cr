class Emeralds::Clean < Emeralds::Command
  def message
    "Emeralds - Cleaning the library files...";
  end

  # Runs the clean script defined in the em.yml file
  def block
    -> {
      Emeralds::CompilerOptionsHelper.clean_script;
    };
  end
end
