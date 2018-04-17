require 'readline'

require_relative 'console'
require_relative 'quit'
require_relative 'reload'
require_relative 'restart'
require_relative 'start'
require_relative 'status'
require_relative 'stop'

module Taskmaster

  module Reader

    SUPER_PROMPT = "#{Console::Color::BOLD}TM3000> #{Console::Color::CLEAR}"

    def self.getline()
      begin
        cmd = Readline.readline(SUPER_PROMPT).strip.split(/\s+/)
      rescue
        Taskmaster::quit(nil)
      end

      if cmd.length == 0
        nil
      else
        begin
          Taskmaster.method(cmd[0]).call(cmd[1..-1])
        rescue
          Console::error "#{cmd[0]}: Command not found"
        end
      end
    end
  end
end
