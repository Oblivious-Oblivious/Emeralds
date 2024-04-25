abstract class Emeralds::Command
  private def usage
    puts "emeralds/em [<command>]\n\n";
    puts "Commands:\n";
    puts "    build [app | lib] [debug | release] - Build the application in the `export` directory.\n";
    puts "    run                                 - Run the compiled application.\n";
    puts "    clean                               - Run the clean script\n";
    puts "    help                                - Print this help message.\n";
    puts "    init [name]                         - Initialize a new library with an em.yml file.\n";
    puts "    install [ | dev | all]              - Install dependencies recursively for each included library.\n";
    puts "    list                                - List dependencies in the em file.\n";
    puts "    makefile                            - Generate a makefile for independent compilation\n";
    puts "    loc [ | deps]                       - Count the sloc lines of code in the project\n";
    puts "    test                                - Run the script of tests.\n";
    puts "    version                             - Print the current version of the emerald.\n";
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━".colorize(:dark_gray);
  end
end
