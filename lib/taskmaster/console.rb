module Taskmaster

  module Console

    module Color
      # Embed in a String to clear all previous ANSI sequences.
      CLEAR = "\e[0m"
      # The start of an ANSI bold sequence.
      BOLD = "\e[1m"

      # Set the terminal's foreground ANSI color to black.
      BLACK = "\e[30m"
      # Set the terminal's foreground ANSI color to red.
      RED = "\e[31m"
      # Set the terminal's foreground ANSI color to green.
      GREEN = "\e[32m"
      # Set the terminal's foreground ANSI color to yellow.
      YELLOW = "\e[33m"
      # Set the terminal's foreground ANSI color to blue.
      BLUE = "\e[34m"
      # Set the terminal's foreground ANSI color to magenta.
      MAGENTA = "\e[35m"
      # Set the terminal's foreground ANSI color to cyan.
      CYAN = "\e[36m"
      # Set the terminal's foreground ANSI color to white.
      WHITE = "\e[37m"

      # Set the terminal's background ANSI color to black.
      ON_BLACK = "\e[40m"
      # Set the terminal's background ANSI color to red.
      ON_RED = "\e[41m"
      # Set the terminal's background ANSI color to green.
      ON_GREEN = "\e[42m"
      # Set the terminal's background ANSI color to yellow.
      ON_YELLOW = "\e[43m"
      # Set the terminal's background ANSI color to blue.
      ON_BLUE = "\e[44m"
      # Set the terminal's background ANSI color to magenta.
      ON_MAGENTA = "\e[45m"
      # Set the terminal's background ANSI color to cyan.
      ON_CYAN = "\e[46m"
      # Set the terminal's background ANSI color to white.
      ON_WHITE = "\e[47m"
    end

    def self.error(error)
      puts "#{Color::RED}#{Color::BOLD}taskmaster#{Color::CLEAR}: #{error}"
    end

    def self.warn(error)
      puts "#{Color::YELLOW}#{Color::BOLD}taskmaster#{Color::CLEAR}: #{error}"
    end

    def self.notice(error)
      puts "#{Color::CYAN}#{Color::BOLD}taskmaster#{Color::CLEAR}: #{error}"
    end

    def self.which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each {|ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      nil
    end
  end
end
