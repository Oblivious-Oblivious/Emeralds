class Emeralds::Help < Emeralds::Command
  def message
    "Emeralds - Help/Usage";
  end

  def block
    -> {
      puts "Emeralds v#{Emeralds::VERSION} (#{Emeralds::INSTALL_METHOD}).\n\n";
      puts "emeralds/em [<command>]\n\n";
      puts "Commands:\n";
      puts "    add [<name>]                        - Add a new .c/.h file pair\n";
      puts "    remove [<name>]                     - Remove a .c/.h file pair\n";
      puts "    build [app | lib] [<profile>]       - Build the project in the `export` directory.\n";
      puts "                                            profiles: debug, release, dev, stage, preprod, prod.\n";
      puts "    run                                 - Run the compiled application.\n";
      puts "    clean                               - Run the clean script\n";
      puts "    help                                - Print this help message.\n";
      puts "    init [ | <name>]                    - Initialize a new project; runs an interactive setup when no name is given.\n";
      puts "    install [ | <link> | dev | all]     - Install dependencies into a flattened libs directory.\n";
      puts "    reinstall                           - Reinstall dependencies into a flattened libs directory.\n";
      puts "    uninstall [<name>]                  - Remove a dependency from em.json and libs.\n";
      puts "    list                                - List dependencies and project modules.\n";
      puts "    makefile                            - Generate a makefile for independent compilation\n";
      puts "    loc                                 - Count the significant lines of code in the project\n";
      puts "    lint                                - Lint all project sources with clang-format.\n";
      puts "    test                                - Run the script of tests.\n";
      puts "    version                             - Print the current version of the emerald.\n";
      puts "    update                              - Update emeralds to the newest released version.\n";
      puts "    license                             - Update the license notice based on the em.json value.\n";
      puts "\n#{Options.usage}";
      if File.exists?("em.json")
        scripts = Emfile.instance.scripts;
        if scripts && !scripts.empty?
          puts "\nScripts:\n";
          scripts.each do |name, command|
            [command].flatten.each_with_index do |line, index|
              if index == 0
                puts "    #{name.ljust(35)} - #{line}\n";
              else
                puts "    #{"".ljust(35)}   #{line}\n";
              end
            end
          end
        end
      end
      puts separator;
      exit 0;
    };
  end
end
