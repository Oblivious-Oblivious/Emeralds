abstract class Emeralds::Build
  abstract def build_app(compile_flags);
  abstract def build_lib(compile_flags, display = true);
end
