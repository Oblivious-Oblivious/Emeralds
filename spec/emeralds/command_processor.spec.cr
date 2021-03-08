describe Emeralds::CommandProcessor do
    cmd = Emeralds::CommandProcessor.new;

    it "initializes a new library" do
        cmd.initialize_em_library("testapp").should eq "testapp";
    end

    it "gets library dependencies" do
        Dir.cd "testapp";
        
        # Initials do not have dependencies
        cmd.get_dependencies.should eq 0;
        Dir.cd "..";
    end

    it "installs dependencies" do
        Dir.cd "testapp";
        cmd.install_dependencies.should eq true;
        # Nothing has failed on installing

        # Tries again to test for re-downloading
        cmd.install_dependencies.should eq true;

        Dir.cd "..";
    end

    it "installs development dependencies" do
        Dir.cd "testapp";

        # cSpec as a default dev-dependency
        cmd.install_dev_dependencies.should eq true;

        # Tries again to test for re-downloading
        cmd.install_dev_dependencies.should eq true;
        Dir.cd "..";
    end

    it "compiles as an executable" do
        Dir.cd "testapp";
        cmd.compile_as_executable.should eq true;
        Dir.cd "..";
    end

    it "compiles as a library" do
        Dir.cd "testapp";
        cmd.compile_as_library.should eq true;
        Dir.cd "..";
    end

    it "runs the test script defined in the yaml file" do
        Dir.cd "testapp";
        cmd.run_test_script.should eq true;
        Dir.cd "..";
    end

    it "runs the clean script defined in the yaml file" do
        Dir.cd "testapp";
        cmd.run_clean_script.should eq true;
        Dir.cd "..";
    end

    it "gets the version of the emeralds" do
        Dir.cd "testapp";
        cmd.get_em_version.should eq "testapp v0.1.0";
        Dir.cd "..";
    end

    it "gets the number of files and lines of code in the project" do
        Dir.cd "testapp";
        cmd.count_lines_of_code.should eq [6, 42];
        Dir.cd "..";
    end
end
