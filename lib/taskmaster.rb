require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'
require 'taskmaster/history'
require 'taskmaster/register'

module Taskmaster
    def self.waitMyPids
        Config.getData().each { |c|
            c["procs"].each { |p|
                p p
            }
        }
    end

    def self.main
        History.load()
        Config.load()
        Register.log("launch")

        # TODO: launch all proc with autostart=true

        # TODO: catch sighup -> reload conf
        #                    -> kill all proc?
        #                    -> restart proc?
        Thread.new(waitMyPids)

        while true
            Reader.getline()
        end
    end
end
