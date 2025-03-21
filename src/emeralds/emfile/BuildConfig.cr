class Emeralds::BuildConfig
  include JSON::Serializable;

  property opt : String? = "";
  property version : String? = "";
  property flags : String? = "";
  property warnings : String? = "";
  property libs : String? = "";

  def initialize(
    @opt : String? = nil,
    @version : String? = nil,
    @flags : String? = nil,
    @warnings : String? = nil,
    @libs : String? = nil
  ); end
end
