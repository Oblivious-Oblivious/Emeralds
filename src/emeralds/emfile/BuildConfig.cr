class Emeralds::BuildConfig
  include JSON::Serializable;

  property opt : String = "";
  property version : String = "";
  property flags : String = "";
  property warnings : String = "";
  property libs : String = "";

  def initialize(
    @opt : String = "",
    @version : String = "",
    @flags : String = "",
    @warnings : String = "",
    @libs : String = ""
  ); end
end
