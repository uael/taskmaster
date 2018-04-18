require_relative 'proc'

module Taskmaster
  def self.start(args)
    if args.empty?
      Console.warn('start: need at least 1 argument')
    else
      args.each do |arg|
        Console.notice("start: #{arg}") # TODO
        if not Config.isconfigured arg
          Console.warn("#{arg}: Unconfigured command")
        else
          p = Proc.new Config.getdata[arg]
          p.spawn
        end
      end
    end
  end
end
