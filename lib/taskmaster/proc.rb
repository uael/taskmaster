module Taskmaster
    module Proc
        @@pids = {} # "ls" => {[pid], etc}

        def self.which(cmd)
            exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
            ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
                exts.each do |ext|
                    exe = File.join(path, "#{cmd}#{ext}")
                    return exe if File.executable?(exe) && !File.directory?(exe)
                end
            end
            nil
        end

        def self.launch(name)
            config = Config::getData()[name]
            begin
                if not @@pids.keys.include?(name)
                    @@pids[name] = []
                end

                @@pids[name].push(
                    spawn(
                        config["env"],
                        config["cmd"],
                        {
                            :out => config["stdout"],
                            :err => config["stderr"],
                            :chdir => config["workingdir"],
                            :umask => config["umask"],
                        }
                    )
                )
            rescue Exception => e
                Console.error(e.message)
            end
        end
    end
end
