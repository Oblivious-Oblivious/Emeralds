class Emeralds::CompileFlags::PlatformConfig
  include JSON::Serializable;

  property cc : String? = nil;
  property debug : BuildConfig = BuildConfig.new;
  property release : BuildConfig = BuildConfig.new;

  def initialize(
    @cc : String? = nil,
    @debug : BuildConfig = BuildConfig.new,
    @release : BuildConfig = BuildConfig.new,
  ); end
end
