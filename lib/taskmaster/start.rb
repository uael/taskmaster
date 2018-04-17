require_relative 'proc'

module Taskmaster

  def self.start(args)
    if args.length == 0
      return Console::warn('start: need at least 1 argument')
    else
      args.each {|arg|
        Console::notice("start: #{arg}") # TODO
      }
    end
  end
end
