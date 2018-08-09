module Taskmaster
    module Proc
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
                    pid = Process.spawn(
                        conf["env"],
                        conf["cmd"],
                        {
                            :out => conf["stdout"],
                            :err => conf["stderr"],
                            :chdir => conf["workingdir"],
                            :umask => conf["umask"],
                        }
                    )
                rescue Exception => e
                    Console.error(e.message)
                else
                    conf["procs"].push(
                        {
                            "begintime" => Time.now.to_i,
                            "endtime" => 0,
                            "killtime" => 0,
                            "exitcode" => nil,
                            "pid" => pid
                        }
                    )
                end
            }
        end

        def self.kill(name)
            conf = Config::getData()[name]

            conf["procs"].each { |p|
                if !p["exitcode"].nil?
                    puts "#{name}: not running"
                else
                    p["killtime"] = Time.now.to_i
                    Process.kill(conf["stopsignal"], p["pid"])
                    puts "#{name}: aaaarg"
                end
            }
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
            conf = Config::getData()[name]

            all_dead = true
            conf["procs"].each { |p|
                if p["exitcode"].nil?
                    all_dead = false
                end
            }
            if not all_dead
                return false
            end

            launch_me = false
            if proc["endtime"] - proc["begintime"] < conf["starttime"]
                if conf["retries"] == conf["startretries"]
                    Console.warn("#{name} restarted more than the allowed restart retries")
                    conf["retries"] = 0
                else
                    launch_me = true
                    conf["retries"] += 1
                end
            end

            if conf["autorestart"] == "always" || \
               (conf["autorestart"] == "unexpected" && !conf["exitcodes"].include?(proc["exitcode"]))
                launch_me = true
            end

            if launch_me
                conf["procs"] = []
                Console.notice("#{name}: restarting")
                Proc.launch(name)
            end

        end
    end
end
