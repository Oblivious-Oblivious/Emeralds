class Emeralds::Crystal::Build < Emeralds::Build
  def build_app(compile_flags)
    Terminal.generic_cmd "#{compile_flags.join(" ")} #{Emfile.instance.name}", display: true;
  end

  def build_lib(compile_flags, display = true)
    if display
      puts "#{ARROW} Crystal does not support building as a library.".colorize(:yellow);
    end
    exit 0;
  end
end
