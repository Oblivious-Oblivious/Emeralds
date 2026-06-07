class Emeralds::CompileFlags
  include JSON::Serializable;

  property win32 : PlatformConfig? = nil;
  property linux : PlatformConfig? = nil;
  property darwin : PlatformConfig? = nil;
  property android : PlatformConfig? = nil;
  property freebsd : PlatformConfig? = nil;
  property openbsd : PlatformConfig? = nil;
  property netbsd : PlatformConfig? = nil;
  property dragonfly : PlatformConfig? = nil;
  property unix : PlatformConfig? = nil;

  def initialize(
    @win32 : PlatformConfig? = nil,
    @linux : PlatformConfig? = nil,
    @darwin : PlatformConfig? = nil,
    @android : PlatformConfig? = nil,
    @freebsd : PlatformConfig? = nil,
    @openbsd : PlatformConfig? = nil,
    @netbsd : PlatformConfig? = nil,
    @dragonfly : PlatformConfig? = nil,
    @unix : PlatformConfig? = nil,
  ); end

  private def missing_platform_config
    operating_system = current_platform[0];

    puts "No compile-flags configuration found for #{operating_system}.".colorize(:red);
    puts "#{ARROW} Add options such as this under `compile-flags` in em.json:";
    puts %(
"#{operating_system}": {
  "debug": ["your", "debug", "compiler", "flags"],
  "release": ["your", "release", "flags"]
}
);
    exit 0;
  end

  private def missing_mode_config(mode)
    operating_system = current_platform[0];

    puts "No `#{mode}` compile-flags configuration found for #{operating_system}.".colorize(:red);
    puts "#{ARROW} Add options such as this under `compile-flags` in em.json:";
    puts %(
"#{operating_system}": {
  "#{mode}": ["your", "compiler", "flags"]
}
);
    exit 0;
  end

  private def selected_platform
    current_platform[1] || missing_platform_config
  end

  private def flags_for(mode, flags)
    flags.empty? ? missing_mode_config(mode) : flags;
  end

  def debug
    flags_for "debug", selected_platform.debug
  end

  def release
    flags_for "release", selected_platform.release
  end

  def dev
    flags_for "dev", selected_platform.dev
  end

  def stage
    flags_for "stage", selected_platform.stage
  end

  def preprod
    flags_for "preprod", selected_platform.preprod
  end

  def prod
    flags_for "prod", selected_platform.prod
  end
end
