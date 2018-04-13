require "readline"
require "tm_config"


module Tm_exec
    def self.status(args)
        if args.length == 0
            puts("status: all")  # TODO
        else
            args.each { |arg|
                puts("status: #{arg}")  # TODO
            }
        end
    end

    def self.start(args)
        if args.length == 0
            return puts("start: need at least 1 argument")
        else
            args.each { |arg|
                puts("start: #{arg}")  # TODO
            }
        end
    end

    def self.stop(args)
        if args.length != 1
            return puts("stop: need at least 1 argument")
        else
            args.each { |arg|
                puts("stop: #{arg}")  # TODO
            }
        end
    end

    def self.restart(args)
        if args.length != 1
            return puts("restart: need at least 1 argument")
        else
            args.each { |arg|
                Tm_exec::start(arg)
                Tm_exec::stop(arg)
            }
        end
    end

    def self.reload(args)
        if args.length > 0
            return puts("reload: too many arguments")
        end

        Tm_config::load()
    end

    def self.quit(args)
        puts("kthxbye")
        exit
    end
end


module Tm_reader
    SUPER_PROMPT = "TM3000> "
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

        if !Tm_reader::SUPER_CMD.keys.include?(cmd[0])
            puts("Command not found: " + cmd[0])
            return false
        end

        ret = true
        cmd[1..-1].each { |arg|
            if !Tm_config::isConfigured(arg)
                puts("Program '#{arg}' is not configured")
                ret = false
            end
        }
        return ret
    end

    def self.getLine()
        begin
            cmd = Readline.readline(Tm_reader::SUPER_PROMPT).strip.split(/\s+/)
        rescue
            Tm_exec::quit(nil)
        end

        if Tm_reader::isValidLine(cmd)
            Tm_exec::method(Tm_reader::SUPER_CMD[cmd[0]]).call(cmd[1..-1])
        end
    end
end
