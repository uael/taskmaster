require "readline"
require "tm_config"


module Tm_exec
    def self.status(args)
        if args.length == 0
            puts("status: all")  # TODO
        else
            args.each { |arg|
                if !Tm_config::programExists(arg)
                    puts("Program not found: #{arg}")
                else
                    puts("status: #{arg}")  # TODO
                end
            }
        end
    end

    def self.start(args)
        if args.length == 0
            return puts("start: need at least 1 argument")
        else
            args.each { |arg|
                if !Tm_config::programExists(arg)
                    puts("Program not found: #{arg}")
                else
                    puts("start: #{arg}")  # TODO
                end
            }
        end
    end

    def self.stop(args)
        if args.length != 1
            return puts("stop: need at least 1 argument")
        else
            args.each { |arg|
                if !Tm_config::programExists(arg)
                    puts("Program not found: #{arg}")
                else
                    puts("stop: #{arg}")  # TODO
                end
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

    def self.getLine()
        begin
            cmd = Readline.readline(Tm_reader::SUPER_PROMPT).strip.split(/\s+/)
        rescue
            Tm_exec::quit(nil)
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
