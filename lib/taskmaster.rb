require "taskmaster/version"
require "tm_config"
require "tm_reader"


module Taskmaster
    def self.main()
        Tm_config::load()

        while true
            Tm_reader::getLine()
        end
    end
end
