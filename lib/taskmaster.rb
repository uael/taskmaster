require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'
require 'taskmaster/history'
require 'taskmaster/register'

module Taskmaster
    def self.main
        # TODO: store the filename to a const
        # TODO: move the save/load logic to read or config module
        History.load(ENV['HOME'] + '/.tmst')
        Config.load()
        Register.log("launch")

        while true
            Reader.getline()
        end
    end
end
