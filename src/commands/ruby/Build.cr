class Emeralds::Ruby::Build < Emeralds::Build
  def build_app(compile_flags)
    puts "#{ARROW} Ruby is interpreted; nothing to build. Use `em run`.".colorize(:yellow);
    exit 0;
  end

  def build_lib(compile_flags, display = true)
    puts "#{ARROW} Ruby is interpreted; nothing to build. Use `em run`.".colorize(:yellow);
    exit 0;
  end
end
