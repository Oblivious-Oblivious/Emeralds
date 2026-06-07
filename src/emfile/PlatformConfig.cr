class Emeralds::CompileFlags::PlatformConfig
  include JSON::Serializable;

  property debug = [] of String;
  property release = [] of String;
  property dev = [] of String;
  property stage = [] of String;
  property preprod = [] of String;
  property prod = [] of String;

  def initialize(
    @debug = [] of String,
    @release = [] of String,
    @dev = [] of String,
    @stage = [] of String,
    @preprod = [] of String,
    @prod = [] of String,
  ); end
end
