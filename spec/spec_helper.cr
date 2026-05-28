require "spec";
require "../src/emeralds.libs";

ROOT    = File.expand_path File.join(__DIR__, "..");
EM      = File.join ROOT, "bin", "emeralds";
SANDBOX = File.join ROOT, "__full-flow__";
PROJECT = File.join SANDBOX, "__testing__";

private def run_em(args : String, dir : String) : String
  io = IO::Memory.new;
  Process.run EM, args.split.reject(&.empty?), chdir: dir, output: io, error: io;
  io.to_s;
end

def em(args : String) : String
  run_em args, PROJECT;
end

def em_sandbox(args : String) : String
  run_em args, SANDBOX;
end

def em_at(args : String, dir : String) : String
  run_em args, dir;
end
