require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'
require 'taskmaster/history'
require 'taskmaster/register'

module Taskmaster
    def self.main
        History.load()
        Config.load()
        Register.log("launch")

        # TODO: launch all proc with autostart=true

        # TODO: catch sighup -> reload conf
        #                    -> kill all proc?
        #                    -> restart proc?
        Thread.new {
            loop do
                c = Config.getData()
                c.keys.each { |k|
                    c[k]["procs"].each { |p|
                        #TODO: waitMyPIDnonBlockingChercheSurInternetDirectFaisPasChier
                    }
                }
            end

            # TODO: check if procs are still alive and stuffs
        }

        while true
            Reader.getline()
        end
    end
end
