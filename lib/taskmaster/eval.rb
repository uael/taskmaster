require 'readline'

require_relative 'console'
require_relative 'history'
require_relative 'config'
require_relative 'register'
require_relative 'proc'

module Taskmaster

    module Eval
        def self.status(args)
            if args.length == 0
                args = Config.getData().keys
            end

            args.each { |arg|
                Proc.status(arg)
            }
        end

        def self.start(args)
            if args.length == 0
                return Console.warn("start: need at least 1 argument")
            end

            args.each { |arg|
                Proc.launch(arg)
            }
        end

        def self.stop(args)
            if args.length == 0
                return Console.warn("stop: need at least 1 argument")
            end

            args.each { |arg|
                Proc.kill(arg)
            }
        end

        def self.restart(args)
            if args.length == 0
                return Console.warn("restart: need at least 1 argument")
            end
            conf = Config.getData()

            args.each { |arg|
                Eval::stop([arg])

                startretries = conf[arg]["startretries"]
                autorestart = conf[arg]["autorestart"]
                conf[arg]["startretries"] = 0
                conf[arg]["autorestart"] = "never"

                all_dead = false
                while !all_dead
                    all_dead = true
                    conf[arg]["procs"].each { |p|
                        if p["exitcode"].nil?
                            all_dead = false
                        end
                    }
                    sleep(0.1)
                end

                conf[arg]["startretries"] = startretries
                conf[arg]["autorestart"] = autorestart
                conf[arg]["retries"] = 0
                conf[arg]["procs"] = []  # makes sense

                Eval::start([arg])
            }
        end

        def self.reload(args)
            if args.length > 0
                return Console.warn("reload: too many arguments")
            end

            Config::reload()
        end

        def self.quit(args)
            History.save()
            Register::log("quit")

            conf = Config.getData()
            conf.keys.each { |k|
                conf[k]["procs"].each { |p|
                    if p["exitcode"].nil?
                        begin
                            Process.kill(Signal.list["KILL"], p["pid"])
                            Console.notice("killing remaining process #{k}: #{p['pid']}")
                        rescue
                            #haha
                        end
                    end
                }
            }
            puts("kthxbye")
            exit
        end
    end

end
