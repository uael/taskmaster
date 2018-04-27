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

        while true
            Reader.getline()
        end
    end
end
