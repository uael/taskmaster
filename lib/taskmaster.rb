require 'pp'                    # DEBUG

require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'
require 'taskmaster/console'
require 'taskmaster/history'
require 'taskmaster/register'
require 'taskmaster/proc'

module Taskmaster
    def self.main
        History.load()
        Config.load()
        Register.log("launch")

        conf = Config.getData()
        conf.keys.each { |k|
            if conf[k]["autostart"]
                Proc.launch(k)
            end
        }

        Signal.trap("HUP") {
            Config.reload()
        }

        Thread.new {
            loop do
                conf = Config.getData()
                conf.keys.each { |k|
                    conf[k]["procs"].each { |p|
                        if p["exitcode"].nil?
                            pid = nil
                            begin
                                pid = Process.wait(p["pid"], Process::WNOHANG)
                            rescue # alive
                                if p["killtime"] > 0 and Time.now.to_i - p["killtime"] > conf[k]["stoptime"]
                                    Console.warn("#{k} was still running after its stoptime delay, killing it now")
                                    Process.kill(Signal.list["KILL"], p["pid"])
                                end
                            else
                                if !pid.nil?
                                    if $?.exitstatus.nil?
                                        p["exitcode"] = 128 + $?.termsig
                                    else
                                        p["exitcode"] = $?.exitstatus
                                    end
                                    p["endtime"] = Time.now.to_i
                                    Proc.undertaker(k, p)
                                end
                            end
                        end
                    }
                }
                sleep(0.1)
            end
        }

        while true
            Reader.getline()
        end

        # don't write code here
    end
end
