require_relative 'proc'

module Taskmaster
  def self.status(args)
    if args.empty?
      Console.notice('status: all') # TODO
    else
      args.each do |arg|
        Console.notice("status: #{arg}") # TODO
      end
    end
  end
end
