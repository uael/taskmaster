require 'readline'

require_relative 'console'
require_relative 'history'
require_relative 'config'
require_relative 'register'

module Taskmaster

    module Eval
        def self.status(args)
            if args.length == 0
                Console.notice("status: all")  # TODO
            else
                args.each { |arg|
                    Console.notice("status: #{arg}")  # TODO
                }
            end
        end

        def self.start(args)
            if args.length == 0
                return Console.warn("start: need at least 1 argument")
            end

            args.each { |arg|
                # TODO: move the start logic somewhere else (proc?)
                begin
                    p = Proc.new(Config::getdata()[arg])
                    p.spawn()
                rescue Exception => ex
                    Console.error("#{arg}: #{ex.message}")  # TODO
                end
            }
        end

        def self.stop(args)
            if args.length != 1
                return Console.warn("stop: need at least 1 argument")
            end

            args.each { |arg|
                Console.notice("stop: #{arg}")  # TODO
            }
        end

        def self.restart(args)
            if args.length != 1
                return Console.warn("restart: need at least 1 argument")
            end

            args.each { |arg|
                Eval::start(arg)
                Eval::stop(arg)
            }
        end

        def self.reload(args)
            if args.length > 0
                return Console.warn("reload: too many arguments")
            end

            Config::load()
        end

        def self.quit(args)
            # TODO: store the filename to a const
            History.save(ENV['HOME'] + '/.tmst')
            Register::log("quit")
            puts("kthxbye")
            exit
        end
    end

end
