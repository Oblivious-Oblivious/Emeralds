class Emeralds::CompileFlags
  include JSON::Serializable;

  property cc : String = "";
  property debug : BuildConfig = BuildConfig.new;
  property release : BuildConfig = BuildConfig.new;

  def initialize(
    @cc : String = "",
    @debug : BuildConfig = BuildConfig.new,
    @release : BuildConfig = BuildConfig.new,
  ); end
end
