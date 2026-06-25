class String
  def blank?
    strip.empty?;
  end

  def posix_path
    gsub('\\', '/');
  end

  def to_c_identifier
    gsub(/[\s\/-]+/, "_");
  end

  def to_ruby_crystal_namespace
    split("/")
      .reject(&.empty?)
      .map(&.split(/[\s_-]+/)
        .reject(&.empty?)
        .map(&.sub(/^./, &.upcase)).join
      )
      .join("::");
  end

  def without_c_extension
    ends_with?(".h") || ends_with?(".c") ? rchop(File.extname(self)) : self;
  end
end
