abstract class Emeralds::Add < Emeralds::Command
  @base_name = "";
  @file_name = "";
  @dir_name = "";

  def initialize(name = "", @silent = false)
    super name, @silent;
    if @name.blank?
      puts "Invalid name: #{name}.".colorize(:red);
      exit 0;
    end
    @base_name = @name.without_c_extension;
    @file_name = File.basename @base_name;
    @dir_name = File.dirname @base_name;
    @dir_name = @base_name if @dir_name == ".";
    @dir_name = "" if @dir_name == ".";
    @func_name = @base_name.to_c_identifier;
  end

  private def path(root, ext)
    File.join root, @dir_name, "#{@file_name}.#{ext}";
  end

  protected def include_path(ext)
    @dir_name.empty? ? "#{@file_name}.#{ext}" : "#{@dir_name}/#{@file_name}.#{ext}";
  end

  private def reserved?
    @dir_name.empty? && @file_name == Emfile.instance.name;
  end

  abstract def message;
  abstract def block;
end
