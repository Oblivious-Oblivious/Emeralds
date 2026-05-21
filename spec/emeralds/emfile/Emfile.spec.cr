require "../../spec_helper";

describe Emeralds::Emfile do
  it "parses generated-style JSON and ignores unknown fields" do
    emfile = Emeralds::Emfile.from_json %({
      "name": "test",
      "version": "1.2.3"
    });

    emfile.name.should eq "test";
    emfile.version.should eq "1.2.3";
  end

  it "defaults missing top-level optional fields to nil" do
    emfile = Emeralds::Emfile.from_json %({});

    emfile.name.should be_nil;
    emfile.version.should be_nil;
    emfile.dependencies.should be_nil;
    emfile.dev_dependencies.should be_nil;
    emfile.license.should be_nil;
    emfile.scripts.should be_nil;
    emfile.locignore.extensions.should be_nil;
    emfile.locignore.directories.should be_nil;
    emfile.compile_flags.debug.should be_a(Emeralds::BuildConfig);
    emfile.compile_flags.release.should be_a(Emeralds::BuildConfig);
  end

  it "accepts locignore, scripts, and compile_flags shapes" do
    emfile = Emeralds::Emfile.from_json %({
      "locignore": {
        "extensions": [".h"],
        "directories": ["vendor"]
      },
      "scripts": {
        "build": "cc src/main.c",
        "test": ["cc spec/main.c", "./a.out"]
      },
      "compile-flags": {
        "cc": null,
        "debug": {},
        "release": null
      }
    });

    emfile.locignore.extensions.should eq [".h"];
    emfile.locignore.directories.should eq ["vendor"];

    scripts = emfile.scripts.not_nil!;
    scripts["build"].should eq "cc src/main.c";
    scripts["test"].should eq ["cc spec/main.c", "./a.out"];

    emfile.compile_flags.cc.should be_nil;
    emfile.compile_flags.debug.opt.should eq "";
    emfile.compile_flags.debug.should be_a(Emeralds::BuildConfig);
    emfile.compile_flags.release.should be_a(Emeralds::BuildConfig);
  end

  it "treats explicit null as absent for nilable fields" do
    emfile = Emeralds::Emfile.from_json %({
      "name": null,
      "compile-flags": null,
      "locignore": {"extensions": null, "directories": null}
    });

    emfile.name.should be_nil;
    emfile.compile_flags.should be_a(Emeralds::CompileFlags);
    emfile.locignore.extensions.should be_nil;
    emfile.locignore.directories.should be_nil;
  end

  it "restores the singleton after nested swaps and failures" do
    original = Emeralds::Emfile.from_json %({"name":"original"});
    replacement = Emeralds::Emfile.from_json %({"name":"replacement"});

    Emeralds::Emfile.with_instance original do
      Emeralds::Emfile.with_instance replacement do
        Emeralds::Emfile.instance.name.should eq "replacement";
      end
      Emeralds::Emfile.instance.name.should eq "original";

      expect_raises(Exception, "boom") do
        Emeralds::Emfile.with_instance replacement do
          raise "boom";
        end
      end
      Emeralds::Emfile.instance.name.should eq "original";
    end
  end

  it "detects cSpec in dependency maps" do
    without_cspec = Emeralds::Emfile.from_json %({
      "dependencies": {"other": "owner/other"},
      "dev-dependencies": {}
    });
    with_cspec = Emeralds::Emfile.from_json %({
      "dependencies": {},
      "dev-dependencies": {"cSpec": "Oblivious-Oblivious/cSpec"}
    });

    Emeralds::Emfile.with_instance without_cspec do
      Emeralds::Emfile.cspec_not_on_deps.should be_true;
      Emeralds::Emfile.cspec_not_on_dev_deps.should be_true;
    end

    Emeralds::Emfile.with_instance with_cspec do
      Emeralds::Emfile.cspec_not_on_deps.should be_true;
      Emeralds::Emfile.cspec_not_on_dev_deps.should be_false;
    end
  end
end
