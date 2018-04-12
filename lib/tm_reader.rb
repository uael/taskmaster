require "readline"

module Tm_reader
    SUPER_PROMPT = "TM3000> "

    def self.getLine()
        Readline.readline(Tm_readLine::SUPER_PROMPT).strip.split(/\s+/)
    end
end
