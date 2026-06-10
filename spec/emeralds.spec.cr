require "spec";
require "../src/emeralds.libs";

ROOT    = File.expand_path File.join(__DIR__, "..");
EM      = File.join ROOT, "bin", "emeralds";
SANDBOX = File.join ROOT, "__full-flow__";
PROJECT = File.join SANDBOX, "__testing__";

private def run_em(args, dir)
  io = IO::Memory.new;
  Process.run EM, args.split.reject(&.empty?), chdir: dir, output: io, error: io;
  io.to_s;
end

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

require "./IT/full-flow/step0-build.spec";
require "./IT/full-flow/step1-em-init.spec";
require "./IT/full-flow/step2-em-output.spec";
require "./IT/full-flow/step3-em-test.spec";
require "./IT/full-flow/step4-em-add.spec";
require "./IT/full-flow/step5-em-build.spec";
require "./IT/full-flow/step6-em-rest-of-calls.spec";
require "./IT/full-flow/step7-em-install-link.spec";
require "./IT/full-flow/step8-em-reinstall.spec";
require "./IT/full-flow/step99-cleanup.spec";
