class Emeralds::GenerateMakefile < Emeralds::Command
  def message
    "Emeralds - Generating a makefile...";
  end

  # Generates a makefile for compiling apps without Emeralds
  def block
    -> {
      Emeralds::CompilerOptionsHelper.generate_makefile;
    };
  end
end
