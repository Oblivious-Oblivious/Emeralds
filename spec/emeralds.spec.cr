require "./spec_helper";

module EmeraldsSpec
  EMERALDS_ROOT = File.expand_path("..", __DIR__);
  @@em_bin : String? = nil;

  class Repo
    def initialize(name = "spec")
      EmeraldsSpec.em "init", name;
      Dir.cd name;
      EmeraldsSpec.em "add", "get_value";
    end

    def run(*args)
      EmeraldsSpec.em(*args);
    end
  end

  def self.in_temp_dir
    dir = File.join "/tmp", "emeralds-spec-#{Process.pid}-#{Time.utc.to_unix}-#{rand(1_000_000)}";
    FileUtils.mkdir_p dir;
    begin
      Dir.cd(dir) { yield dir };
    ensure
      FileUtils.rm_rf dir;
    end
  end

  def self.em_bin
    @@em_bin ||= begin
      dir = File.join "/tmp", "emeralds-spec-bin-#{Process.pid}";
      FileUtils.mkdir_p dir;
      bin = File.join dir, "em";

      unless File::Info.executable? bin
        Process.run(
          "crystal",
          ["build", File.join(EMERALDS_ROOT, "src", "emeralds.cr"), "-o", bin],
          output: Process::Redirect::Inherit,
          error: Process::Redirect::Inherit
        ).success?.should be_true;
      end

      bin
    end
  end

  def self.em(*args)
    bin_dir = File.dirname em_bin;
    env = {"PATH" => "#{bin_dir}:#{ENV["PATH"]}"};
    Process.run(
      em_bin,
      args.map(&.to_s),
      env: env,
      output: Process::Redirect::Inherit,
      error: Process::Redirect::Inherit
    ).success?.should be_true;
  end

  def self.with_repo
    in_temp_dir {
      yield Repo.new;
    };
  end
end
