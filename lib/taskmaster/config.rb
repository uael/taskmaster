require 'yaml'

require_relative 'console'

module Taskmaster
    module Config
        RC_FILE = ENV['HOME'] + '/.tmrc.yml'
        MAIN_KEY = 'programs'
        DEFAULT_CONFIG = {
            "cmd" => '/bin/ls',
            "numprocs" => 1,
            "autostart" => true,
            "autorestart" => 'unexpected', # always/never/unexpected
            "exitcodes" => [0],
            "starttime" => 5,
            "startretries" => 3,
            "stopsignal" => 'TERM',
            "stoptime" => 10,
            "stdout" => '/dev/stdout',
            "stderr" => '/dev/stderr',
            "env" => {},
            "workingdir" => '/tmp',
            "umask" => 0o22
        }
        SIGNALS = {
            "HUP" => 1,
            "INT" => 2,
            "QUIT" => 3,
            "ILL" => 4,
            "TRAP" => 5,
            "ABRT" => 6,
            "IOT" => 6,
            "FPE" => 8,
            "KILL" => 9,
            "BUS" => 10,
            "SEGV" => 11,
            "SYS" => 12,
            "PIPE" => 13,
            "ALRM" => 14,
            "TERM" => 15,
            "URG" => 16,
            "STOP" => 17,
            "TSTP" => 18,
            "CONT" => 19,
            "CHLD" => 20,
            "CLD" => 20,
            "TTIN" => 21,
            "TTOU" => 22,
            "POLL" => 23,
            "IO" => 23,
            "XCPU" => 24,
            "XFSZ" => 25,
            "VTALRM" => 26,
            "PROF" => 27,
            "WINCH" => 28,
            "USR1" => 30,
            "USR2" => 31,
        }
        @@data = {}

        def self.getData
            @@data
        end

        def self.isConfigured(prog_name)
            @@data.keys.include?(prog_name)
        end

        def self.create
            unless File.exist?(Config::RC_FILE)
                open(Config::RC_FILE, 'w') do |f|
                    f.puts(YAML.dump(Config::MAIN_KEY => { "editme" => Config::DEFAULT_CONFIG }))
                end
                Console.notice(
                    "A default config has been generated in '#{Config::RC_FILE}'.",
                    'You *might* want to edit it.'
                )
            end
        end

        def self.validate(conf)
            if not conf.is_a?(Hash)
                abort("Invalid config file. (#{Config::RC_FILE})")
            end

            if not File.executable?(conf["cmd"])
                abort("Invalid config file: '#{conf["cmd"]}' not found (#{Config::RC_FILE})")
            end

            if not conf["numprocs"].is_a?(Integer) or conf["numprocs"] < 0
                abort("Invalid config file: invalid numprocs '#{conf["numprocs"]}' (#{Config::RC_FILE})")
            end

            if not conf["autostart"].is_a?(TrueClass) and not conf["autostart"].is_a?(FalseClass)
                abort("Invalid config file: invalid autostart '#{conf["autostart"]}' (#{Config::RC_FILE})")
            end

            if not ["always", "never", "unexpected"].include?(conf["autorestart"])
                abort("Invalid config file: invalid autorestart '#{conf["autorestart"]}' (#{Config::RC_FILE})")
            end

            if not conf["exitcodes"].is_a?(Array)
                abort("Invalid config file: invalid exitcodes '#{conf["exitcodes"]}' (#{Config::RC_FILE})")
            end
            conf["exitcodes"].each { |e|
                if not e.is_a?(Integer)
                    abort("Invalid config file: invalid exitcodes '#{e}' (#{Config::RC_FILE})")
                end
            }

            if not conf["starttime"].is_a?(Integer) or conf["starttime"] < 0
                abort("Invalid config file: invalid starttime '#{conf["starttime"]}' (#{Config::RC_FILE})")
            end

            if not conf["startretries"].is_a?(Integer) or conf["startretries"] < 0
                abort("Invalid config file: invalid startretries '#{conf["startretries"]}' (#{Config::RC_FILE})")
            end

            if not SIGNALS.keys.include?(conf["stopsignal"])
                abort("Invalid config file: invalid stopsignal '#{conf["stopsignal"]}' (#{Config::RC_FILE})")
            end
            conf["stopsignal"] = SIGNALS[conf["stopsignal"]]

            if not conf["stoptime"].is_a?(Integer) or conf["stoptime"] < 0
                abort("Invalid config file: invalid stoptime '#{conf["stoptime"]}' (#{Config::RC_FILE})")
            end

            if not File.writable?(conf["stdout"])
                abort("Invalid config file: '#{conf["stdout"]}' not found (#{Config::RC_FILE})")
            end

            if not File.writable?(conf["stderr"])
                abort("Invalid config file: '#{conf["stderr"]}' not found (#{Config::RC_FILE})")
            end

            if not conf["env"].is_a?(Hash)
                abort("Invalid config file: invalid env '#{conf["env"]}' (#{Config::RC_FILE})")
            end
            conf["env"].keys.each { |k|
                if not k.is_a?(String) or not conf["env"][k].is_a?(String) or k != k.upcase
                    abort("Invalid config file: invalid env '#{k}=#{conf["env"][k]}' (#{Config::RC_FILE})")
                end
            }

            if not File.directory?(conf["workingdir"]) or not File.writable?(conf["workingdir"])
                abort("Invalid config file: '#{conf["workingdir"]}' not found (#{Config::RC_FILE})")
            end

            if not conf["umask"].is_a?(Integer)
                abort("Invalid config file: invalid umask '#{conf["umask"]}' (#{Config::RC_FILE})")
            end
        end

        def self.load
            begin
                create
                data = YAML.load_file(Config::RC_FILE)
            rescue StandardError
                abort("Can't load config file. (#{Config::RC_FILE})")
            end

            if not data.keys.include?(Config::MAIN_KEY)
                abort("Invalid config file: key '#{Config::MAIN_KEY}' not found (#{Config::RC_FILE})")
            end

            data = data[Config::MAIN_KEY]
            data.keys.each { |k|
                begin
                    data[k] = Config::DEFAULT_CONFIG.merge(data[k])
                    validate(data[k])
                rescue
                    abort("Invalid config file. (#{Config::RC_FILE})")
                end
            }
            @@data = data
        end
    end
end
