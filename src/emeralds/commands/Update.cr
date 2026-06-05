class Emeralds::Update < Emeralds::Command
  def message
    "Emeralds - Updating to the latest version...";
  end

  # Parse a `v1.2.3`/`1.2.3` string into a comparable tuple
  #
  # return -> The version tuple or nil when malformed
  private def parse_version(raw)
    parts = raw.lstrip('v').split('.').map(&.to_i?);
    return nil if parts.size != 3;

    major, minor, patch = parts;
    return nil unless major && minor && patch;

    {major, minor, patch};
  end

  # Read the released version straight from `version.cr` on master, which
  # `deploy.rb` bumps before every tag, so it always holds the latest release
  #
  # return -> The version tuple or nil when it cannot be fetched
  private def latest_version
    response = HTTP::Client.get VERSION_URL;
    return nil unless response.success?;
    match = response.body.match(/VERSION = "(\d+\.\d+\.\d+)"/);
    match ? parse_version(match[1]) : nil;
  rescue
    nil;
  end

  # Update the running binary through whichever method installed it,
  # stamped into the binary at build time via `Emeralds::INSTALL_METHOD`
  private def update(version)
    case Emeralds::INSTALL_METHOD
    when "scoop"
      puts "#{ARROW} Run `scoop update emeralds` to update.".colorize(:yellow);
    when "brew"
      puts "#{ARROW} Updating via brew";
      Terminal.generic_cmd "brew update", display: true;
      Terminal.generic_cmd "brew upgrade #{BREW_FORMULA}", display: true;
    when "curl"
      puts "#{ARROW} Updating via curl";
      Terminal.generic_cmd "curl -fsSL https://raw.githubusercontent.com/#{REPO}/v#{version}/scripts/get.sh | sh", display: true;
    else
      puts "#{ARROW} Built from source; rebuild from the repository to update.".colorize(:yellow);
    end
  end

  def block
    -> {
      latest = latest_version;
      if latest.nil?
        puts "#{ARROW} Could not determine the latest version.".colorize(:red);
        return;
      end

      latest_str = "#{latest[0]}.#{latest[1]}.#{latest[2]}";
      current = parse_version Emeralds::VERSION;

      puts "#{ARROW} Current version: v#{Emeralds::VERSION}";
      puts "#{ARROW} Latest version:  v#{latest_str}";

      if current && current >= latest
        puts " #{COG} Already up to date";
        return;
      end

      update latest_str;
    };
  end
end
