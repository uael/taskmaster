require_relative 'proc'

module Taskmaster
  def self.start(args)
    if args.empty?
      Console.warn('start: need at least 1 argument')
    else
      args.each do |arg|
        Console.notice("start: #{arg}") # TODO
      end
    end
  end
end
