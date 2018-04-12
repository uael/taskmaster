require "yaml"

module Tm_config
    RC_FILE = ENV["HOME"] + "/.tmrc"
    MAIN_KEY = "programs"
    DEFAULT_CONFIG = {
        "cmd" => "/bin/command-not-found",
        "numprocs" => 1,
        "autostart" => true,
        "autorestart" => "unexpected",  # always/never/unexpected
        "exitcodes" => [0],
        "starttime" => 5,
        "startretries" => 3,
        "stopsignal" => "TERM",
        "stoptime" => 10,
        "stdout" => "/dev/stdout",
        "stderr" => "/dev/stderr",
        "env" => {},
        "workingdir" => "/tmp",
        "umask" => 022,
    }
    @@data = {}

    def self.getData()
        @@data
    end

    def self.programExists(prog_name)
        @@data.keys.include?(prog_name)
    end

    def self.load()
        begin
            data = YAML.load_file(Tm_config::RC_FILE)
        rescue
            return puts("Can't load config file.")
        end

        if !data.keys.include?(Tm_config::MAIN_KEY)
            nil
        else
            data = data[Tm_config::MAIN_KEY]
            data.keys.each { |k|
                data[k] = DEFAULT_CONFIG.merge(data[k])
            }
            @@data = data
        end
    end
end
