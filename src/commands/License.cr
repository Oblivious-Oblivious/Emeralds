class Emeralds::License < Emeralds::Command
  def wget_license
    puts "  #{ARROW} LICENSE";
    case Emfile.instance.license
    when "mit"
      Terminal.wget "https://mit-license.org/license.txt", "LICENSE";
    when "gpl-v2"
      Terminal.wget "https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt", "LICENSE";
    when "apache-v2"
      Terminal.wget "https://www.apache.org/licenses/LICENSE-2.0.txt", "LICENSE";
    when "gpl-v3"
      Terminal.wget "https://www.gnu.org/licenses/gpl-3.0.txt", "LICENSE";
    when "lgpl-v3"
      Terminal.wget "https://www.gnu.org/licenses/lgpl-3.0.txt", "LICENSE";
    when "mpl-v2"
      Terminal.wget "https://www.mozilla.org/media/MPL/2.0/index.f75d2927d3c1.txt", "LICENSE";
    when "epl-v2"
      Terminal.wget "https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.txt", "LICENSE";
    when "agpl-v3"
      Terminal.wget "https://www.gnu.org/licenses/agpl-3.0.txt", "LICENSE";
    when "cc0-v1"
      Terminal.wget "https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt", "LICENSE";
    when "cc0-v4"
      Terminal.wget "https://creativecommons.org/licenses/by/4.0/legalcode.txt", "LICENSE";
    else
      Terminal.wget "https://mit-license.org/license.txt", "LICENSE";
    end
  end

  def message
    "Emeralds - Downloading license...";
  end

  def block
    -> {
      wget_license;
    };
  end
end
