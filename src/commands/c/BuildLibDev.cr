class Emeralds::C::BuildLibDev < Emeralds::BuildLibDev
  def block
    -> {
      C::Build.new.build_lib Emfile.instance.compile_flags.dev;
    }
  end
end
