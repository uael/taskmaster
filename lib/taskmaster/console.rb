class String
    CLEAR = "\e[0m".freeze
    BOLD = "\e[1m".freeze
    BLACK = "\e[30m".freeze
    RED = "\e[31m".freeze
    GREEN = "\e[32m".freeze
    YELLOW = "\e[33m".freeze
    BLUE = "\e[34m".freeze
    MAGENTA = "\e[35m".freeze
    CYAN = "\e[36m".freeze
    WHITE = "\e[37m".freeze

    def red()     RED     + BOLD + self + CLEAR; end
    def green()   GREEN   + BOLD + self + CLEAR; end
    def yellow()  YELLOW  + BOLD + self + CLEAR; end
    def blue()    BLUE    + BOLD + self + CLEAR; end
    def magenta() MAGENTA + BOLD + self + CLEAR; end
    def cyan()    CYAN    + BOLD + self + CLEAR; end
    def white()   WHITE   + BOLD + self + CLEAR; end
end

module Taskmaster

    module Console
        PREFIX = "taskmaster: ".freeze

        def self.error(msg)  puts("#{PREFIX.red}#{msg}"); end
        def self.warn(msg)   puts("#{PREFIX.yellow}#{msg}"); end
        def self.notice(msg) puts("#{PREFIX.cyan}#{msg}"); end
    end
end
