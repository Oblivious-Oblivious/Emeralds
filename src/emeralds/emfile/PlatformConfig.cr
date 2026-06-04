class Emeralds::CompileFlags::PlatformConfig
  include JSON::Serializable;

  property debug = [] of String;
  property release = [] of String;

  def initialize(
    @debug = [] of String,
    @release = [] of String,
  ); end
end
