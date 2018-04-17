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
