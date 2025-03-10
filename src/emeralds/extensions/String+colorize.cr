class String
  def colorize(color)
    case color
    when :green       then "\033[38;5;78m#{self}\033[0m"
    when :red         then "\033[38;5;203m#{self}\033[0m"
    when :yellow      then "\033[38;5;11m#{self}\033[0m"
    when :purple      then "\033[1;38;5;175m#{self}\033[0m"
    when :cyan        then "\033[38;5;51m#{self}\033[0m"
    when :gray        then "\033[38;5;244m#{self}\033[0m"
    when :white       then "\033[38;5;15m#{self}\033[0m"
    when :dark_gray   then "\033[38;5;240m#{self}\033[0m"
    else                   self
    end
  end

  def mode(mode)
    case mode
    when :bold then "\033[1m#{self}\033[0m"
    when :dim  then "\033[2m#{self}\033[0m"
    else            self
    end
  end
end
