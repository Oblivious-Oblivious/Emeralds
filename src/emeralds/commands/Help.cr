class Emeralds::Help < Emeralds::Command
  def message
    "Emeralds - Help/Usage";
  end

  def block
    -> {
      puts "emeralds/em [<command>]\n\n";
      puts "Commands:\n";
      puts "    add [<name>]                        - Add a new .c/.h file pair\n";
      puts "    build [app | lib] [debug | release] - Build the application in the `export` directory.\n";
      puts "    run                                 - Run the compiled application.\n";
      puts "    clean                               - Run the clean script\n";
      puts "    help                                - Print this help message.\n";
      puts "    init [<name>]                       - Initialize a new library with an em.json file.\n";
      puts "    install [ | dev | all]              - Install dependencies recursively for each included library.\n";
      puts "    reinstall                           - Reinstall dependencies recursively for each included library.\n";
      puts "    list                                - List dependencies in the em file.\n";
      puts "    makefile                            - Generate a makefile for independent compilation\n";
      puts "    loc                                 - Count the significant lines of code in the project\n";
      puts "    test                                - Run the script of tests.\n";
      puts "    version                             - Print the current version of the emerald.\n";
      puts "    license                             - Update the license notice based on the em.yml value.\n";
      puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
      exit 0;
    };
  end
end
