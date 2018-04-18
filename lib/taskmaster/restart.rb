require_relative 'proc'

module Taskmaster
  def self.restart(args)
    if args.length != 1
      Console.warn('restart: need at least 1 argument')
    else
      args.each do |arg|
        Taskmaster.start(arg)
        Taskmaster.stop(arg)
      end
    end
  end
end
