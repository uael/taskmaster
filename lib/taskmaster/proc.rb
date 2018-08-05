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
                            "starttime" => Time.now,
                            "stoptime" => 0,
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

            # TODO: check return code -> restart if needed: conf["autorestart"]
            # TODO: in wait callback? -> "abort" (just log an error?) if time.now - time_of_launch > conf["starttime"]
        end

        def self.kill(name)
            # TODO: check if the proc is actually running

            # TODO: time_of_death = time.now
            # TODO: send conf["stopsignal"] to the proc
            puts "#{name}: aaaarg"
            # TODO: in wait callback? -> SIGKILL if time.now - time_of_death > conf["stoptime"]
        end

        def self.status(name)
            # TODO: display some infos about the proc here -> at least if it's running or not
            puts "#{name}: I'm ok thank you"
        end
    end
end
