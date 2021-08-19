def write_em_file
    File.write "em.yml", "name: testapp\nversion: 0.1.0\n\ndependencies:\n  cSpec: Oblivious-Oblivious/cSpec\n  cDataLib: Oblivious-Oblivious/cDataLib\n\nlicense: GPLv3\n\napplication: make\nlibrary: make lib\ntest: make test\nclean: make clean\n";
end

describe Emeralds::YamlHelper do
    context "when em.yml file does not exist" do
        it "fails to read the file and prints a friendly statement" do
            Dir.cd "spec";
            Emeralds::YamlHelper.get_dependencies.should eq [] of String;
            Dir.cd "..";
        end
    end

    context "when em.yml file exists" do
        it "returns the list of dependencies" do
            Dir.cd "spec";

            write_em_file;
            Emeralds::YamlHelper.get_dependencies.should eq ["\"cSpec\" => \"Oblivious-Oblivious/cSpec\"", "\"cDataLib\" => \"Oblivious-Oblivious/cDataLib\""];
            FileUtils.rm_rf "em.yml";

            Dir.cd "..";
        end
    end

    it "gets the name field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("name").should eq "testapp";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "gets the version field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("version").should eq "0.1.0";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "gets the license field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("license").should eq "GPLv3";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "gets the application field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("application").should eq "make";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "gets the library field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("library").should eq "make lib";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "gets the test field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("test").should eq "make test";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "gets the clean field from the yaml file" do
        Dir.cd "spec";
        write_em_file;

        Emeralds::YamlHelper.get_field("clean").should eq "make clean";

        FileUtils.rm_rf "em.yml";
        Dir.cd "..";
    end

    it "counts the lines of code in the whole project" do
        Dir.cd "spec";
        `em init testapp`;
        Dir.cd "testapp";

        Emeralds::YamlHelper.get_lines_of_code.should eq [6, 42];

        Dir.cd "..";
        FileUtils.rm_rf "testapp";
        Dir.cd "..";
    end
end
