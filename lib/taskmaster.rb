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
                        #TODO: waitMyPIDnonBlockingChercheSurInternetDirectFaisPasChier
                    }
                }
                sleep(0.1)
            end

            # TODO: check if procs are still alive and stuffs
        }

        while true
            Reader.getline()
        end

        # TODO: kill all remaining process (aka: zombie slaughter)
        # Process.detach(pid)
    end
end
