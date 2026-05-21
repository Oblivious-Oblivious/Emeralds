class Emeralds::Ignore
  include JSON::Serializable;

  property extensions : Array(String)? = [] of String;
  property directories : Array(String)? = [] of String;

  def initialize(
    @extensions : Array(String)? = nil,
    @directories : Array(String)? = nil
  ); end
end
