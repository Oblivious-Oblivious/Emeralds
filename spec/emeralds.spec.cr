require "spec";
require "../src/emeralds.libs";

ROOT = File.expand_path File.join(__DIR__, "..");
EM   = File.join ROOT, "bin", "emeralds";

private def run_em(args, dir)
  io = IO::Memory.new;
  Process.run EM, args.split.reject(&.empty?), chdir: dir, output: io, error: io;
  io.to_s;
end

# C flow (default template). Kept at top level so the existing
# spec/IT/full-flow/c/*.spec files work verbatim.
SANDBOX = File.join ROOT, "__full-flow-c__";
PROJECT = File.join SANDBOX, "__testing__";

def em(args)
  run_em args, PROJECT;
end

def em_sandbox(args)
  run_em args, SANDBOX;
end

def em_at(args, dir)
  run_em args, dir;
end

def em_raw(args, dir = PROJECT)
  io = IO::Memory.new;
  Process.run EM, args, chdir: dir, output: io, error: io;
  io.to_s;
end

# Crystal flow.
module CrystalFlow
  SANDBOX = File.join ROOT, "__full-flow-crystal__";
  PROJECT = File.join SANDBOX, "__testing__";

  def crystal_em(args)
    run_em args, PROJECT;
  end

  def crystal_em_sandbox(args)
    run_em args, SANDBOX;
  end

  def crystal_em_at(args, dir)
    run_em args, dir;
  end

  def crystal_em_raw(args, dir = PROJECT)
    io = IO::Memory.new;
    Process.run EM, args, chdir: dir, output: io, error: io;
    io.to_s;
  end

  def self.tools?
    Process.find_executable("crystal") && Process.find_executable("shards");
  end
end

# Ruby flow.
module RubyFlow
  SANDBOX = File.join ROOT, "__full-flow-ruby__";
  PROJECT = File.join SANDBOX, "__testing__";

  def ruby_em(args)
    run_em args, PROJECT;
  end

  def ruby_em_sandbox(args)
    run_em args, SANDBOX;
  end

  def ruby_em_at(args, dir)
    run_em args, dir;
  end

  def ruby_em_raw(args, dir = PROJECT)
    io = IO::Memory.new;
    Process.run EM, args, chdir: dir, output: io, error: io;
    io.to_s;
  end

  def self.tools?
    Process.find_executable("ruby") && Process.find_executable("bundle");
  end
end

require "./IT/full-flow/c/step0-build.spec";
require "./IT/full-flow/c/step1-em-init.spec";
require "./IT/full-flow/c/step2-em-output.spec";
require "./IT/full-flow/c/step3-em-test.spec";
require "./IT/full-flow/c/step4-em-add.spec";
require "./IT/full-flow/c/step5-em-build.spec";
require "./IT/full-flow/c/step6-em-rest-of-calls.spec";
require "./IT/full-flow/c/step7-em-install-link.spec";
require "./IT/full-flow/c/step8-em-reinstall.spec";
require "./IT/full-flow/c/step99-cleanup.spec";

require "./IT/full-flow/crystal/step0-build.spec";
require "./IT/full-flow/crystal/step1-em-init.spec";
require "./IT/full-flow/crystal/step2-em-output.spec";
require "./IT/full-flow/crystal/step3-em-test.spec";
require "./IT/full-flow/crystal/step4-em-add.spec";
require "./IT/full-flow/crystal/step5-em-build.spec";
require "./IT/full-flow/crystal/step6-em-rest-of-calls.spec";
require "./IT/full-flow/crystal/step7-em-install-link.spec";
require "./IT/full-flow/crystal/step8-em-reinstall.spec";
require "./IT/full-flow/crystal/step99-cleanup.spec";

require "./IT/full-flow/ruby/step0-build.spec";
require "./IT/full-flow/ruby/step1-em-init.spec";
require "./IT/full-flow/ruby/step2-em-output.spec";
require "./IT/full-flow/ruby/step3-em-test.spec";
require "./IT/full-flow/ruby/step4-em-add.spec";
require "./IT/full-flow/ruby/step5-em-build.spec";
require "./IT/full-flow/ruby/step6-em-rest-of-calls.spec";
require "./IT/full-flow/ruby/step7-em-install-link.spec";
require "./IT/full-flow/ruby/step8-em-reinstall.spec";
require "./IT/full-flow/ruby/step99-cleanup.spec";
