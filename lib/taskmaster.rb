require "time"

require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'
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

        # TODO: catch sighup -> reload conf
        #                    -> kill all proc?
        #                    -> restart proc?
        Thread.new {
            loop do
                conf = Config.getData()
                conf.keys.each { |k|
                    conf[k]["procs"].each { |p|
                        if p["exitcode"].nil?
                            begin
                                Process.kill(p["pid"], 0)  # is it still alive?
                            rescue # nop
                                Process.wait(p["pid"])
                                p["exitcode"] = $?.exitstatus
                                p["endtime"] = Time.now
                                Proc.undertaker(k, p)
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
