require_relative 'proc'

module Taskmaster

  def self.restart(args)
    if args.length != 1
      return Console::warn("restart: need at least 1 argument")
    else
      args.each {|arg|
        Taskmaster::start(arg)
        Taskmaster::stop(arg)
      }
    end
  end
end
