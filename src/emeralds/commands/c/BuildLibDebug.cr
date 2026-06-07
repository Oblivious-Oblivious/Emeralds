class Emeralds::C::BuildLibDebug < Emeralds::BuildLibDebug
  def block
    -> {
      C::Build.new.build_lib Emfile.instance.compile_flags.debug;
    }
  end
end
