require 'yaml'

require_relative 'console'
require_relative 'proc'

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
            "starttime" => 0,  # < 0 == disabled
            "startretries" => 3,
            "stopsignal" => 'TERM',
            "stoptime" => 10,
            "stdout" => '/dev/null',
            "stderr" => '/dev/null',
            "env" => {},
            "workingdir" => '/tmp',
            "umask" => 0o22,
            "procs" => [],
            "retries" => 0
        }

        PROC = {
            "pid" => nil,
            "begintime" => 0,
            "endtime" => 0,
            "killtime" => 0,
            "exitcode" => nil,
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
                Console.error("Invalid config file. (#{Config::RC_FILE})")
                return false
            end

            cmd = conf["cmd"].split(/\s+/)[0]
            zboub = Proc.which(cmd)
            if zboub.nil?
                Console.error("Invalid config file: '#{conf["cmd"]}' not found (#{Config::RC_FILE})")
                return false
            end
            conf["cmd"].sub(cmd, zboub)

            if not conf["numprocs"].is_a?(Integer) or conf["numprocs"] < 0
                Console.error("Invalid config file: invalid numprocs '#{conf["numprocs"]}' (#{Config::RC_FILE})")
                return false
            end

            if not conf["autostart"].is_a?(TrueClass) and not conf["autostart"].is_a?(FalseClass)
                Console.error("Invalid config file: invalid autostart '#{conf["autostart"]}' (#{Config::RC_FILE})")
                return false
            end

            if not ["always", "never", "unexpected"].include?(conf["autorestart"])
                Console.error("Invalid config file: invalid autorestart '#{conf["autorestart"]}' (#{Config::RC_FILE})")
                return false
            end

            if not conf["exitcodes"].is_a?(Array)
                Console.error("Invalid config file: invalid exitcodes '#{conf["exitcodes"]}' (#{Config::RC_FILE})")
                return false
            end
            conf["exitcodes"].each { |e|
                if not e.is_a?(Integer)
                    Console.error("Invalid config file: invalid exitcodes '#{e}' (#{Config::RC_FILE})")
                    return false
                end
            }

            if not conf["starttime"].is_a?(Integer) or conf["starttime"] < 0
                Console.error("Invalid config file: invalid starttime '#{conf["starttime"]}' (#{Config::RC_FILE})")
                return false
            end

            if not conf["startretries"].is_a?(Integer) or conf["startretries"] < 0
                Console.error("Invalid config file: invalid startretries '#{conf["startretries"]}' (#{Config::RC_FILE})")
                return false
            end

            if not Signal.list.keys.include?(conf["stopsignal"])
                Console.error("Invalid config file: invalid stopsignal '#{conf["stopsignal"]}' (#{Config::RC_FILE})")
                return false
            end
            conf["stopsignal"] = Signal.list[conf["stopsignal"]]

            if not conf["stoptime"].is_a?(Integer) or conf["stoptime"] < 0
                Console.error("Invalid config file: invalid stoptime '#{conf["stoptime"]}' (#{Config::RC_FILE})")
                return false
            end

            if File.exists?(conf["stdout"]) and not File.writable?(conf["stdout"])
                Console.error("Invalid config file: '#{conf["stdout"]}' not writable (#{Config::RC_FILE})")
                return false
            end

            if File.exists?(conf["stderr"]) and not File.writable?(conf["stderr"])
                Console.error("Invalid config file: '#{conf["stderr"]}' not writable (#{Config::RC_FILE})")
                return false
            end

            if not conf["env"].is_a?(Hash)
                Console.error("Invalid config file: invalid env '#{conf["env"]}' (#{Config::RC_FILE})")
                return false
            end
            conf["env"].keys.each { |k|
                if not conf["env"][k].is_a?(String)
                    conf["env"][k] = conf["env"][k].to_s
                end
            }

            if not File.directory?(conf["workingdir"]) or not File.writable?(conf["workingdir"])
                Console.error("Invalid config file: '#{conf["workingdir"]}' not found (#{Config::RC_FILE})")
                return false
            end

            if not conf["umask"].is_a?(Integer)
                Console.error("Invalid config file: invalid umask '#{conf["umask"]}' (#{Config::RC_FILE})")
                return false
            end

            true
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
                data[k] = Config::DEFAULT_CONFIG.merge(data[k])
                data[k]["procs"] = []  # makes sense
                if !validate(data[k])
                    abort()
                end
            }
            @@data = data
        end

        def self.reload
            begin
                data = YAML.load_file(Config::RC_FILE)
            rescue StandardError
                Console.error("Can't reload config file. (#{Config::RC_FILE})")
                return false
            end

            if not data.keys.include?(Config::MAIN_KEY)
                Console.error("Invalid config file: key '#{Config::MAIN_KEY}' not found (#{Config::RC_FILE})")
                return false
            end

            data = data[Config::MAIN_KEY]
            data.keys.each { |k|
                data[k] = Config::DEFAULT_CONFIG.merge(data[k])
                data[k]["procs"] = []  # makes sense
                if !validate(data[k])
                    return false
                end
            }

            super_k_array = []

            old_conf = Config.getData()
            old_conf.keys.each { |k|
                if !data.key?(k)
                    tmp = old_conf[k]["procs"]
                    old_conf[k]["procs"] = []
                    tmp.each { |p|
                        begin
                            Process.kill(Signal.list["KILL"], p["pid"])
                            Console.log("killing #{k}: #{p['pid']} due to reload (not used anymore)")
                        rescue
                            #haha
                        end
                    }
                else
                    tmp = old_conf[k]["procs"]
                    old_conf[k]["procs"] = []
                    old_conf[k]["retries"] = 0
                    if data[k] != old_conf[k]
                        tmp.each { |p|
                            begin
                                Process.kill(Signal.list["KILL"], p["pid"])
                                Console.log("killing #{k}: #{p['pid']} due to reload (not used anymore)")
                            rescue
                                #haha
                            end
                        }
                        super_k_array.push(k)
                    else
                        data[k]["procs"] = tmp
                    end
                end
            }

            data.keys.each { |k|
                if data[k]["autostart"] \
                  and data[k]["procs"].length == 0 and !super_k_array.include?(k)
                    super_k_array.push(k)
                end

            }
            @@data = data

            super_k_array.each { |k|
                Proc.launch(k)
            }

            true
        end
    end
end
