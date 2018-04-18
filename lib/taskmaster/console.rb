module Taskmaster
  module Console
    module Color
      # Embed in a String to clear all previous ANSI sequences.
      CLEAR = "\e[0m".freeze
      # The start of an ANSI bold sequence.
      BOLD = "\e[1m".freeze

      # Set the terminal's foreground ANSI color to black.
      BLACK = "\e[30m".freeze
      # Set the terminal's foreground ANSI color to red.
      RED = "\e[31m".freeze
      # Set the terminal's foreground ANSI color to green.
      GREEN = "\e[32m".freeze
      # Set the terminal's foreground ANSI color to yellow.
      YELLOW = "\e[33m".freeze
      # Set the terminal's foreground ANSI color to blue.
      BLUE = "\e[34m".freeze
      # Set the terminal's foreground ANSI color to magenta.
      MAGENTA = "\e[35m".freeze
      # Set the terminal's foreground ANSI color to cyan.
      CYAN = "\e[36m".freeze
      # Set the terminal's foreground ANSI color to white.
      WHITE = "\e[37m".freeze

      # Set the terminal's background ANSI color to black.
      ON_BLACK = "\e[40m".freeze
      # Set the terminal's background ANSI color to red.
      ON_RED = "\e[41m".freeze
      # Set the terminal's background ANSI color to green.
      ON_GREEN = "\e[42m".freeze
      # Set the terminal's background ANSI color to yellow.
      ON_YELLOW = "\e[43m".freeze
      # Set the terminal's background ANSI color to blue.
      ON_BLUE = "\e[44m".freeze
      # Set the terminal's background ANSI color to magenta.
      ON_MAGENTA = "\e[45m".freeze
      # Set the terminal's background ANSI color to cyan.
      ON_CYAN = "\e[46m".freeze
      # Set the terminal's background ANSI color to white.
      ON_WHITE = "\e[47m".freeze
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
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end
      nil
    end

    def self.spawn(cmd, &block)
      # see: http://stackoverflow.com/a/1162850/83386
      Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
        # read each stream from a new thread
        {:out => stdout, :err => stderr}.each do |key, stream|
          Thread.new do
            until (line = stream.gets).nil? do
              # yield the block depending on the stream
              if key == :out
                yield line, nil, thread if block_given?
              else
                yield nil, line, thread if block_given?
              end
            end
          end
        end

        thread
      end
    end
  end
end
