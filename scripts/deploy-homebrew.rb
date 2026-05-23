#!/usr/bin/env ruby

require "digest";
require "fileutils";
require "open-uri";
require "open3";
require "uri";

ROOT = File.expand_path("..", __dir__);
REPO = "Oblivious-Oblivious/Emeralds";
TAP = ENV.fetch("HOMEBREW_TAP_DIR", File.expand_path("~/work/homebrew-tap"));
FORMULA = File.join(TAP, "Formula", "emeralds.rb");

def die(msg)
  warn "deploy-homebrew: #{msg}";
  exit 1;
end

def run!(*args, chdir: ROOT)
  out, ok = Open3.capture2e(*args, chdir: chdir);
  die(out.strip) unless ok.success?;
  out;
end

def run(*args, chdir: ROOT)
  system(*args, chdir: chdir) || die("command failed: #{args.join(" ")}");
end

def ok?(*args)
  _, status = Open3.capture2e(*args, chdir: ROOT);
  status.success?;
end

version = ARGV[0];
die("usage: em deploy:homebrew <version> (example: em deploy:homebrew 0.10.1)") if version.to_s.empty?;
die("invalid version: #{version}") unless version.match?(/\A\d+\.\d+\.\d+\z/);

tag = "v#{version}";
url = "https://github.com/#{REPO}/archive/refs/tags/#{tag}.tar.gz";
header = "# Changes for Emeralds #{version}";

Dir.chdir(ROOT);
%w[git gh crystal shards].each { |c| die("#{c} is required") unless system("command", "-v", c, out: File::NULL) };
die("homebrew tap not found at #{TAP}") unless File.directory?(File.join(TAP, ".git"));
die("tag #{tag} already exists locally") if system("git", "rev-parse", tag, out: File::NULL, err: File::NULL);
die("tag #{tag} already exists on origin") unless `git ls-remote --tags origin refs/tags/#{tag} 2>/dev/null`.strip.empty?;
die("working tree has uncommitted changes; commit or stash before releasing") unless ok?("git", "diff", "--quiet") && ok?("git", "diff", "--cached", "--quiet");

puts "deploy-homebrew: bumping to #{version}";
File.write("shard.yml", File.read("shard.yml").sub(/^version: .+/, "version: #{version}"));
File.write("src/emeralds/constants/version.cr", File.read("src/emeralds/constants/version.cr").sub(/VERSION = "[^"]+"/, "VERSION = \"#{version}\""));
unless File.read("CHANGELOG.md").include?("#{header} ")
  File.write("CHANGELOG.md", "#{header} (#{Time.now.strftime("%b %d %Y")})\n\n#{File.read("CHANGELOG.md")}");
end
die("failed to update version.cr") unless File.read("src/emeralds/constants/version.cr")[/VERSION = "([^"]+)"/, 1] == version;

puts "deploy-homebrew: verifying build";
run("shards", "install");
run("shards", "build", "--release", "--no-debug");

branch = run!("git", "rev-parse", "--abbrev-ref", "HEAD").strip;
puts "deploy-homebrew: committing version bump";
run("git", "add", "shard.yml", "src/emeralds/constants/version.cr");
run!("git", "commit", "-m", "[master] - new version.");

notes = [];
found = false;
File.foreach("CHANGELOG.md") do |line|
  found = true if line.start_with?("#{header} ");
  next unless found;
  break if line.start_with?("# Changes for Emeralds ") && !line.start_with?("#{header} ");
  notes << line unless line.start_with?("#{header} ");
end
notes = notes.join.strip;
notes = "Release #{tag}." if notes.empty?;

puts "deploy-homebrew: tagging #{tag}";
run!("git", "tag", "-a", tag, "-m", "[master] - new version.");
puts "deploy-homebrew: pushing #{branch} and #{tag}";
run!("git", "push", "origin", branch);
run!("git", "push", "origin", tag);

puts "deploy-homebrew: creating GitHub release";
run!("gh", "release", "create", tag, "--repo", REPO, "--title", "Emeralds #{tag}", "--notes", notes);

puts "deploy-homebrew: fetching tarball checksum";
begin
  sha256 = Digest::SHA256.hexdigest(URI.open(url).read);
rescue OpenURI::HTTPError => e
  die("failed to fetch #{url}: #{e.io.status[0]}");
end
die("failed to compute sha256 for #{url}") if sha256.empty?;

puts "deploy-homebrew: updating formula at #{FORMULA}";
FileUtils.mkdir_p(File.dirname(FORMULA));
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

Dir.chdir(TAP) do
  run("git", "add", "Formula/emeralds.rb");
  die("no formula changes to commit in #{TAP}") if ok?("git", "diff", "--cached", "--quiet");
  run!("git", "commit", "-m", "[master] - updated emeralds to #{version}");
  run!("git", "push", "-u", "origin", "HEAD");
end

puts "deploy-homebrew: done (#{tag}, sha256 #{sha256})";
