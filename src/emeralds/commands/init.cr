require "./command";

class Emeralds::Init < Emeralds::Command
  def message
    "Emeralds - Initializing a new project";
  end

  # Initialize a new emfile with the name specified
  def block
    -> {
      Emeralds::CommandProcessor.usage if ARGV.size < 2;

      Emeralds::FileCreatorHelper.name = ARGV[1];
      Emeralds::FileCreatorHelper.create_lib_directory;
      puts "#{COG} Writing initial files:";
      Emeralds::FileCreatorHelper.write_em_file;
      Emeralds::FileCreatorHelper.initialize_git_directory;
      Emeralds::FileCreatorHelper.wget_a_gplv3_license;
      Emeralds::FileCreatorHelper.write_gitignore_file;
      Emeralds::FileCreatorHelper.generate_readme;
      Emeralds::FileCreatorHelper.create_source_directories;
      Emeralds::FileCreatorHelper.create_source_files;
      Emeralds::FileCreatorHelper.create_spec_files;
    };
  end
end
