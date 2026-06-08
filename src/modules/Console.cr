module Emeralds::Console
  private def self.read_line_plain(prompt)
    print prompt;
    STDOUT.flush;
    gets;
  end

  private def self.read_line_raw(prompt)
    buffer = [] of Char;
    pos = 0;
    result = nil;

    print prompt;
    STDOUT.flush;

    STDIN.raw do |io|
      loop do
        char = io.read_char;
        break if char.nil?;

        case char
        when '\r', '\n'
          result = buffer.join;
          break;
        when '\u0003'
          break;
        when '\u0004'
          break if buffer.empty?;
        when '\u007F', '\b'
          if pos > 0
            buffer.delete_at pos - 1;
            pos -= 1;
          end
        when '\e'
          case read_escape io
          when "[C", "OC"        then pos += 1 if pos < buffer.size;
          when "[D", "OD"        then pos -= 1 if pos > 0;
          when "[H", "[1~", "OH" then pos = 0;
          when "[F", "[4~", "OF" then pos = buffer.size;
          when "[3~"             then buffer.delete_at pos if pos < buffer.size;
          end
        else
          unless char.control?
            buffer.insert pos, char;
            pos += 1;
          end
        end

        redraw_line prompt, buffer, pos;
      end
    end

    print "\r\n";
    STDOUT.flush;
    result;
  end

  private def self.redraw_line(prompt, buffer, pos)
    print "\r\e[K";
    print prompt;
    print buffer.join;
    back = buffer.size - pos;
    print "\e[#{back}D" if back > 0;
    STDOUT.flush;
  end

  private def self.select_plain(question, options, default)
    loop do
      print "#{question} (#{options.join(", ")}) [#{default}]: ";
      STDOUT.flush;
      input = gets;
      return nil if input.nil?;
      choice = input.strip;
      choice = default if choice.empty?;
      choice = choice.downcase;
      return choice if options.includes? choice;
      puts "Invalid choice: #{choice}. Available: #{options.join(", ")}.".colorize(:red);
    end
  end

  private def self.select_raw(question, options, default)
    index = options.index(default) || 0;
    result = nil;

    print "#{question} #{"(↑/↓, Enter)".colorize(:dark_gray)}\r\n";
    STDOUT.flush;

    STDIN.raw do |io|
      draw_menu options, index, true;
      loop do
        char = io.read_char;
        break if char.nil?;

        case char
        when '\r', '\n'
          result = options[index];
          break;
        when '\u0003', '\u0004'
          break;
        when '\e'
          case read_escape io
          when "[A", "OA" then index = (index - 1) % options.size;
          when "[B", "OB" then index = (index + 1) % options.size;
          end
        end

        draw_menu options, index, false;
      end
    end

    result;
  end

  private def self.draw_menu(options, index, first)
    print "\e[#{options.size}A" unless first;
    options.each_with_index do |option, i|
      line = i == index ? "❯ #{option}".colorize(:green).mode(:bold) : "  #{option}";
      print "\r\e[K#{line}\r\n";
    end
    STDOUT.flush;
  end

  private def self.read_escape(io)
    first = io.read_char;
    return "" if first.nil?;
    return first.to_s unless first == '[' || first == 'O';

    String.build do |str|
      str << first;
      loop do
        c = io.read_char;
        break if c.nil?;
        str << c;
        break unless c.ascii_number?;
      end
    end
  end

  def self.prompt(question)
    value = STDIN.tty? ? read_line_raw(question) : read_line_plain(question);
    value.try(&.strip);
  end

  def self.select(question, options, default = options.first)
    return select_plain question, options, default unless STDIN.tty?;
    select_raw question, options, default;
  end
end
