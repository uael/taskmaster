require_relative 'proc'

module Taskmaster
  def self.stop(args)
    if args.length != 1
      Console.warn('stop: need at least 1 argument')
    else
      args.each do |arg|
        Console.notice("stop: #{arg}") # TODO
      end
    end
  end
end
