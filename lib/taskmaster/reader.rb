require 'readline'

require_relative 'console'
require_relative 'config'
require_relative 'register'
require_relative 'eval'

module Taskmaster

    module Reader
        SUPER_PROMPT = "TM3000> ".white.freeze
        SUPER_CMD = {
            "status" => :status,
            "start" => :start,
            "stop" => :stop,
            "restart" => :restart,
            "reload" => :reload,
            "quit" => :quit,
            "exit" => :quit,
        }

        def self.isValidLine(cmd)
            if cmd.length == 0
                return false
            end

            if !Reader::SUPER_CMD.keys.include?(cmd[0])
                Console.error("Command not found: " + cmd[0])
                return false
            end

            ret = true
            cmd[1..-1].each { |arg|
                if !Config::isConfigured(arg)
                    Console.warn("#{arg}: Unconfigured command")
                    ret = false
                end
            }
            return ret
        end

        def self.getline
            stty_save = `stty -g`.chomp
            trap('INT', 'SIG_IGN')

            Readline.completion_append_character = " "
            Readline.completion_proc = proc { |s|
                SUPER_CMD.keys.sort.grep(/^#{Regexp.escape(s)}/)
            }

            begin
                line = Readline.readline(Reader::SUPER_PROMPT, true)
                cmd = line.strip.split(/\s+/)
            rescue Interrupt
                system('stty', stty_save) # Restore
                Eval.quit(nil)
            rescue StandardError
                Eval.quit(nil)
            end

            if Reader::isValidLine(cmd)
                Register::log(line)
                Eval::method(Reader::SUPER_CMD[cmd[0]]).call(cmd[1..-1])
            end
        end
    end

end
