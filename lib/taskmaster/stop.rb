require_relative 'proc'

module Taskmaster

  def self.stop(args)
    if args.length != 1
      return Console::warn("stop: need at least 1 argument")
    else
      args.each {|arg|
        Console::notice("stop: #{arg}") # TODO
      }
    end
  end
end
