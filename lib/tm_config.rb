require "yaml"


module Tm_config
    RC_FILE = ENV["HOME"] + "/.tmrc.yml"
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

    def self.create()
        if not File.exist?(Tm_config::RC_FILE)
            open(Tm_config::RC_FILE, "w") { |f|
                f.puts(YAML.dump({Tm_config::MAIN_KEY => {"editme" => Tm_config::DEFAULT_CONFIG}}))
            }
            puts(
                "A default config has been generated in '#{Tm_config::RC_FILE}'.",
                "You *might* want to edit it."
            )
        end
    end

    def self.load()
        begin
            Tm_config::create()
            data = YAML.load_file(Tm_config::RC_FILE)
        rescue
            abort("Can't load config file. (#{Tm_config::RC_FILE})")
        end

        if data.keys.include?(Tm_config::MAIN_KEY)
            data = data[Tm_config::MAIN_KEY]
            data.keys.each { |k|
                data[k] = DEFAULT_CONFIG.merge(data[k])
            }
            # TODO: sanitize data from config file
            @@data = data
        end
    end
end
