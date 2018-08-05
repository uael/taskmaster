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
            config = Config::getData()[name]
            begin
                config["procs"].push(
                    {
                        "starttime" => Time.now,
                        "stoptime" => 0,
                        "exitcode" => nil,
                        "pid" => Process.spawn(
                            config["env"],
                            config["cmd"],
                            {
                                :out => config["stdout"],
                                :err => config["stderr"],
                                :chdir => config["workingdir"],
                                :umask => config["umask"],
                            }
                        )
                    }
                )
            rescue Exception => e
                Console.error(e.message)
            end

            # TODO: launch config["numprocs"] instances
            # TODO: check return code -> restart if needed: config["autorestart"]
            # TODO: in wait callback? -> "abort" (just log an error?) if time.now - time_of_launch > config["starttime"]
        end

        def self.kill(name)
            # TODO: check if the proc is actually running

            # TODO: time_of_death = time.now
            # TODO: send config["stopsignal"] to the proc
            puts "#{name}: aaaarg"
            # TODO: in wait callback? -> SIGKILL if time.now - time_of_death > config["stoptime"]
        end

        def self.status(name)
            # TODO: display some infos about the proc here -> at least if it's running or not
            puts "#{name}: I'm ok thank you"
        end
    end
end
