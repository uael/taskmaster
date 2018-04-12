require "readline"

module Tm_exec
    def self.status(args)
        if args.length == 0
            puts("status: all")
        else
            args.each { |arg|
                puts("status: #{arg}")  # TODO
            }
        end
    end

    def self.start(args)
        if args.length != 1
            return puts("start: need 1 argument")
        end

        puts("start: #{args[0]}")  # TODO
    end

    def self.stop(args)
        if args.length != 1
            return puts("stop: need 1 argument")
        end

        puts("stop: #{args[0]}")  # TODO
    end

    def self.restart(args)
        if args.length != 1
            return puts("restart: need 1 argument")
        end

        puts("restart: #{args[0]}")  # TODO
    end

    def self.reload(args)
        if args.length > 0
            return puts("reload: too many arguments")
        end

        puts("reload")  # TODO
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
    }

    def self.getLine()
        begin
            cmd = Readline.readline(Tm_readLine::SUPER_PROMPT).strip.split(/\s+/)
        rescue
            return puts("nop")
        end

        if cmd.length == 0
            nil
        elsif !Tm_reader::SUPER_CMD.keys.include?(cmd[0])
            puts("Command not found: " + cmd[0])
        else
            Tm_exec::method(Tm_reader::SUPER_CMD[cmd[0]]).call(cmd[1..-1])
        end
    end
end
