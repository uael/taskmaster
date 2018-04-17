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
    SUPER_PROMPT = "#{Console::Color::BOLD}TM3000> #{Console::Color::CLEAR}".freeze

    def self.getline
      stty_save = `stty -g`.chomp
      trap('INT', 'SIG_IGN')

      begin
        cmd = Readline.readline(SUPER_PROMPT, true).strip.split(/\s+/)
      rescue Interrupt
        system('stty', stty_save) # Restore
        Taskmaster.quit(nil)
      rescue StandardError
        Taskmaster.quit(nil)
      end

      if cmd.empty?
        nil
      else
        begin
          Taskmaster.method(cmd[0]).call(cmd[1..-1])
        rescue StandardError
          Console.error "#{cmd[0]}: Command not found"
        end
      end
    end
  end
end
