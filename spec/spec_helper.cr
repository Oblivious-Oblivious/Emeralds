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
