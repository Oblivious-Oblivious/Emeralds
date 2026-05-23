#!/usr/bin/env ruby

require "digest";
require "open-uri";
require "open3";

ROOT = File.expand_path("..", __dir__);
REPO = "Oblivious-Oblivious/Emeralds";
TAP = File.expand_path(ENV.fetch("HOMEBREW_TAP_DIR", "~/work/homebrew-tap"));
FORMULA = File.join(TAP, "emeralds.rb");

def die(m)
  warn m;
  exit 1;
end

def cmd(*a, chdir: ROOT)
  system(*a, chdir: chdir) || die("failed: #{a.join(" ")}");
end

def cmd!(*a, chdir: ROOT)
  out, ok = Open3.capture2e(*a, chdir: chdir);
  die(out) unless ok.success?;
  out;
end

version = ARGV[0] or die("usage: em deploy:homebrew <version>");
die("bad version") unless version.match?(/\A\d+\.\d+\.\d+\z/);

tag = "v#{version}";
url = "https://github.com/#{REPO}/archive/refs/tags/#{tag}.tar.gz";
header = "# Changes for Emeralds #{version}";

Dir.chdir(ROOT);
die("dirty tree") unless cmd!("git", "diff", "--quiet") && cmd!("git", "diff", "--cached", "--quiet");
die("tag exists") if system("git", "rev-parse", tag, out: File::NULL, err: File::NULL);
die("tag on origin") unless `git ls-remote --tags origin refs/tags/#{tag}`.strip.empty?;

File.write("shard.yml", File.read("shard.yml").sub(/^version: .+/, "version: #{version}"));
File.write("src/emeralds/constants/version.cr", File.read("src/emeralds/constants/version.cr").sub(/VERSION = "[^"]+"/, "VERSION = \"#{version}\""));
unless File.read("CHANGELOG.md").include?("#{header} ")
  File.write("CHANGELOG.md", "#{header} (#{Time.now.strftime("%b %d %Y")})\n\n#{File.read("CHANGELOG.md")}");
end

# cmd("shards", "install");
cmd("shards", "build", "--release", "--no-debug");
branch = cmd!("git", "rev-parse", "--abbrev-ref", "HEAD").strip;
cmd("git", "add", "shard.yml", "src/emeralds/constants/version.cr");
cmd!("git", "commit", "-m", "[master] - new version.");

cmd!("git", "tag", "-a", tag, "-m", "[master] - new version.");
cmd!("git", "push", "origin", branch);
cmd!("git", "push", "origin", tag);

sha256 = Digest::SHA256.hexdigest(URI.open(url).read);
File.write(FORMULA, <<~RUBY);
  class Emeralds < Formula
    desc "A package manager for C"
    homepage "https://github.com/#{REPO}"
    url "#{url}"
    sha256 "#{sha256}"
    license "MIT"

    depends_on "crystal" => :build

    def install
      system "shards", "build", "--release", "--no-debug"
      bin.install "bin/emeralds"
      bin.install_symlink bin/"emeralds" => "em"
    end

    test do
      assert_match "init", shell_output("\#{bin}/em help")
    end
  end
RUBY

cmd("git", "add", "emeralds.rb", chdir: TAP);
cmd!("git", "commit", "-m", "[master] - updated emeralds to #{version}", chdir: TAP);
cmd!("git", "push", "-u", "origin", "HEAD", chdir: TAP);
