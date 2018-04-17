require_relative 'proc'

module Taskmaster

  def self.status(args)
    if args.length == 0
      Console::notice("status: all") # TODO
    else
      args.each {|arg|
        Console::notice("status: #{arg}") # TODO
      }
    end
  end
end
