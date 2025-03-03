module Colorize
  GREEN       = "\033[38;5;78m";
  RED         = "\033[38;5;203m";
  YELLOW      = "\033[38;5;11m";
  PURPLE      = "\033[1;38;5;175m";
  CYAN        = "\033[38;5;51m";
  GRAY        = "\033[38;5;244m";
  WHITE       = "\033[38;5;15m";
  DARK_GRAY   = "\033[38;5;240m";
  RESET       = "\033[0m";
  BACK_PURPLE = "\033[48;5;96m";
  BACK_GRAY   = "\033[48;5;240m\033[38;5;247m";

  BOLD = "\033[1m";
  DIM  = "\033[2m";

  enum Color
    Green
    Red
    Yellow
    Purple
    Cyan
    Gray
    White
    DarkGray
  end

  enum Mode
    Bold
    Dim
  end
end

class String
  def colorize(color : Colorize::Color) : String
    case color
    when .green?       then Colorize::GREEN + self + Colorize::RESET
    when .red?         then Colorize::RED + self + Colorize::RESET
    when .yellow?      then Colorize::YELLOW + self + Colorize::RESET
    when .purple?      then Colorize::PURPLE + self + Colorize::RESET
    when .cyan?        then Colorize::CYAN + self + Colorize::RESET
    when .gray?        then Colorize::GRAY + self + Colorize::RESET
    when .white?       then Colorize::WHITE + self + Colorize::RESET
    when .dark_gray?   then Colorize::DARK_GRAY + self + Colorize::RESET
    else self
    end
  end

  def mode(mode : Colorize::Mode) : String
    case mode
    when .bold? then Colorize::BOLD + self + Colorize::RESET
    when .dim?  then Colorize::DIM + self + Colorize::RESET
    else self
    end
  end

  def colorize(color_symbol : Symbol) : String
    color = case color_symbol
    when :green       then Colorize::Color::Green
    when :red         then Colorize::Color::Red
    when :yellow      then Colorize::Color::Yellow
    when :purple      then Colorize::Color::Purple
    when :cyan        then Colorize::Color::Cyan
    when :gray        then Colorize::Color::Gray
    when :white       then Colorize::Color::White
    when :dark_gray   then Colorize::Color::DarkGray
    else Colorize::Color::White
    end

    colorize(color);
  end
end
