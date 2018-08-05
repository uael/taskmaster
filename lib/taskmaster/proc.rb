require "time"

module Taskmaster
    module Proc
        @@pids = {} # "ls" => {[pid], etc}

        def self.which(cmd)
            if File.executable?(cmd)
                return cmd
            end
            exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
            ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
                exts.each do |ext|
                    exe = File.join(path, "#{cmd}#{ext}")
                    return exe if File.executable?(exe) && !File.directory?(exe)
                end
            end
            nil
        end

        # TODO: loop the whole function config["startretries"] times till it succeeds
        def self.launch(name)
            conf = Config::getData()[name]
            (1..conf["numprocs"]).each {
                begin
                    conf["procs"].push(
                        {
                            "begintime" => Time.now,
                            "endtime" => 0,
                            "killtime" => 0,
                            "exitcode" => nil,
                            "pid" => Process.spawn(
                                conf["env"],
                                conf["cmd"],
                                {
                                    :out => conf["stdout"],
                                    :err => conf["stderr"],
                                    :chdir => conf["workingdir"],
                                    :umask => conf["umask"],
                                }
                            )
                        }
                    )
                rescue Exception => e
                    Console.error(e.message)
                end
            }
        end

        def self.kill(name, force=false)
            # conf = Config::getData()[name]
            # TODO: check if the proc is actually running

            # TODO: time_of_death = time.now
            # TODO: send conf["stopsignal"] to the proc
            puts "#{name}: aaaarg"
            # TODO: in wait callback? -> SIGKILL if time.now - time_of_death > conf["stoptime"]
        end

        def self.status(name)
            conf = Config::getData()[name]
            for i in 1..conf["procs"].length
                if conf["procs"][i - 1]["exitcode"].nil?
                    puts "#{name} ##{i}: I'm ok thank you"
                else
                    puts "dead-#{name} ##{i}: wooooo!"
                end
                # TODO: add more infos?
            end
        end

        def self.undertaker(name, proc)
            # TODO: check return code -> restart if needed: conf["autorestart"]
            conf = Config::getData()[name]
            if proc["endtime"] - proc["begintime"] < conf["starttime"]
                Console.warn("#{name} finished before its configured starttime")
                # TODO: restart?
            end
        end
    end
end
