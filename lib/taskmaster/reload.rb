require_relative 'proc'

module Taskmaster
  def self.reload(args)
    return Console.warn('reload: too many arguments') unless args.empty?

    Taskmaster::Config.load
  end
end
